import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import { Mail, RefreshCw, Plus, Trash2, Clock, CheckCircle, AlertCircle, Users, Pencil } from "lucide-react";
import { detectEmailTypo } from "@/utils/emailValidation";
interface Invitation {
  id: string;
  parent_email: string;
  status: string;
  created_at: string;
  expires_at: string;
}

interface ParentRelation {
  id: string;
  parent_user_id: string;
}

export const ParentInvitationManager = () => {
  const [invitations, setInvitations] = useState<Invitation[]>([]);
  const [parentRelations, setParentRelations] = useState<ParentRelation[]>([]);
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const [newEmail, setNewEmail] = useState("");
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingInvitation, setEditingInvitation] = useState<Invitation | null>(null);
  const [editEmail, setEditEmail] = useState("");
  const [typoWarning, setTypoWarning] = useState<{ email: string; suggestion: string } | null>(null);
  const { toast } = useToast();

  const fetchData = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) return;

      // Fetch invitations
      const { data: invitationsData, error: invError } = await supabase
        .from("parent_invitations")
        .select("*")
        .eq("eleve_user_id", user.id)
        .order("created_at", { ascending: false });

      if (invError) throw invError;
      setInvitations(invitationsData || []);

      // Fetch parent relations
      const { data: relationsData, error: relError } = await supabase
        .from("parent_eleve_relations")
        .select("*")
        .eq("eleve_user_id", user.id);

      if (relError) throw relError;
      setParentRelations(relationsData || []);
    } catch (error) {
      console.error("Error fetching parent data:", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const getInvitationStatus = (invitation: Invitation) => {
    if (invitation.status === "accepted") return "accepted";
    const now = new Date();
    const expiresAt = new Date(invitation.expires_at);
    if (expiresAt < now) return "expired";
    return "pending";
  };

  const resendInvitation = async (invitation: Invitation) => {
    setSending(true);
    try {
      // Delete old invitation
      const { error: deleteError } = await supabase
        .from("parent_invitations")
        .delete()
        .eq("id", invitation.id);

      if (deleteError) throw deleteError;

      // Send new invitation via edge function
      const { error: invokeError } = await supabase.functions.invoke("invite-parents", {
        body: { parentEmails: [invitation.parent_email] }
      });

      if (invokeError) throw invokeError;

      toast({
        title: "Invitation renvoyée",
        description: `Un nouvel email a été envoyé à ${invitation.parent_email}`,
      });

      fetchData();
    } catch (error) {
      console.error("Error resending invitation:", error);
      toast({
        title: "Erreur",
        description: "Impossible de renvoyer l'invitation",
        variant: "destructive",
      });
    } finally {
      setSending(false);
    }
  };

  const updateInvitationEmail = async (invitation: Invitation, newEmailAddress: string) => {
    const trimmedEmail = newEmailAddress.trim();
    if (!trimmedEmail) return;

    // Vérifier les fautes de frappe
    const typoCheck = detectEmailTypo(trimmedEmail);
    if (typoCheck.hasTypo && typoCheck.suggestedEmail) {
      setTypoWarning({ email: trimmedEmail, suggestion: typoCheck.suggestedEmail });
      return;
    }

    setSending(true);
    try {
      // Supprimer l'ancienne invitation
      const { error: deleteError } = await supabase
        .from("parent_invitations")
        .delete()
        .eq("id", invitation.id);

      if (deleteError) throw deleteError;

      // Envoyer une nouvelle invitation avec le nouvel email
      const { error: invokeError } = await supabase.functions.invoke("invite-parents", {
        body: { parentEmails: [trimmedEmail] }
      });

      if (invokeError) throw invokeError;

      toast({
        title: "Email modifié",
        description: `L'invitation a été envoyée à ${trimmedEmail}`,
      });

      setEditingInvitation(null);
      setEditEmail("");
      setTypoWarning(null);
      fetchData();
    } catch (error) {
      console.error("Error updating invitation:", error);
      toast({
        title: "Erreur",
        description: "Impossible de modifier l'invitation",
        variant: "destructive",
      });
    } finally {
      setSending(false);
    }
  };

  const confirmTypoAndSend = async (invitation: Invitation | null) => {
    if (typoWarning && typoWarning.suggestion) {
      if (invitation) {
        // Mode édition: mettre à jour avec l'email corrigé
        setEditEmail(typoWarning.suggestion);
        setTypoWarning(null);
        await updateInvitationEmail(invitation, typoWarning.suggestion);
      } else {
        // Mode ajout: mettre à jour le champ avec l'email corrigé
        setNewEmail(typoWarning.suggestion);
        setTypoWarning(null);
      }
    }
  };

  const ignoreTypoAndSend = async (invitation: Invitation | null, originalEmail: string) => {
    setTypoWarning(null);
    if (invitation) {
      // Mode édition: forcer l'envoi avec l'email original
      setSending(true);
      try {
        const { error: deleteError } = await supabase
          .from("parent_invitations")
          .delete()
          .eq("id", invitation.id);

        if (deleteError) throw deleteError;

        const { error: invokeError } = await supabase.functions.invoke("invite-parents", {
          body: { parentEmails: [originalEmail] }
        });

        if (invokeError) throw invokeError;

        toast({
          title: "Email modifié",
          description: `L'invitation a été envoyée à ${originalEmail}`,
        });

        setEditingInvitation(null);
        setEditEmail("");
        fetchData();
      } catch (error) {
        console.error("Error updating invitation:", error);
        toast({
          title: "Erreur",
          description: "Impossible de modifier l'invitation",
          variant: "destructive",
        });
      } finally {
        setSending(false);
      }
    }
  };

  const deleteInvitation = async (invitationId: string) => {
    try {
      const { error } = await supabase
        .from("parent_invitations")
        .delete()
        .eq("id", invitationId);

      if (error) throw error;

      toast({
        title: "Invitation supprimée",
      });

      fetchData();
    } catch (error) {
      console.error("Error deleting invitation:", error);
      toast({
        title: "Erreur",
        description: "Impossible de supprimer l'invitation",
        variant: "destructive",
      });
    }
  };

  const sendNewInvitation = async () => {
    if (!newEmail.trim()) return;

    setSending(true);
    try {
      const { error } = await supabase.functions.invoke("invite-parents", {
        body: { parentEmails: [newEmail.trim()] }
      });

      if (error) throw error;

      toast({
        title: "Invitation envoyée",
        description: `Un email a été envoyé à ${newEmail}`,
      });

      setNewEmail("");
      setShowAddForm(false);
      fetchData();
    } catch (error) {
      console.error("Error sending invitation:", error);
      toast({
        title: "Erreur",
        description: "Impossible d'envoyer l'invitation",
        variant: "destructive",
      });
    } finally {
      setSending(false);
    }
  };

  const totalParentsAndInvitations = parentRelations.length + 
    invitations.filter(i => getInvitationStatus(i) === "pending").length;
  const canAddMore = totalParentsAndInvitations < 2;

  if (loading) {
    return (
      <Card>
        <CardContent className="py-8">
          <div className="flex items-center justify-center">
            <RefreshCw className="h-6 w-6 animate-spin text-muted-foreground" />
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Users className="h-5 w-5" />
          Gestion des parents
        </CardTitle>
        <CardDescription>
          Invitez jusqu'à 2 parents pour suivre votre progression ({parentRelations.length}/2 parents liés)
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Parent relations */}
        {parentRelations.length > 0 && (
          <div className="space-y-2">
            <h4 className="text-sm font-medium text-muted-foreground">Parents liés</h4>
            {parentRelations.map((relation) => (
              <div key={relation.id} className="flex items-center justify-between p-3 bg-muted/50 rounded-lg">
                <div className="flex items-center gap-2">
                  <CheckCircle className="h-4 w-4 text-green-500" />
                  <span className="text-sm">Parent connecté</span>
                </div>
                <Badge variant="secondary">Actif</Badge>
              </div>
            ))}
          </div>
        )}

        {/* Invitations */}
        {invitations.length > 0 && (
          <div className="space-y-2">
            <h4 className="text-sm font-medium text-muted-foreground">Invitations</h4>
            {invitations.map((invitation) => {
              const status = getInvitationStatus(invitation);
              const isEditing = editingInvitation?.id === invitation.id;
              
              return (
                <div key={invitation.id} className="p-3 bg-muted/50 rounded-lg space-y-2">
                  {isEditing ? (
                    // Mode édition
                    <div className="space-y-3">
                      <div className="flex items-center gap-2">
                        <Pencil className="h-4 w-4 text-primary" />
                        <span className="text-sm font-medium">Modifier l'email</span>
                      </div>
                      <div className="flex gap-2">
                        <Input
                          type="email"
                          placeholder="nouvel.email@exemple.com"
                          value={editEmail}
                          onChange={(e) => setEditEmail(e.target.value)}
                          className="flex-1"
                        />
                        <Button 
                          size="sm" 
                          onClick={() => updateInvitationEmail(invitation, editEmail)}
                          disabled={sending || !editEmail.trim()}
                        >
                          {sending ? <RefreshCw className="h-4 w-4 animate-spin" /> : "Valider"}
                        </Button>
                        <Button 
                          size="sm" 
                          variant="outline"
                          onClick={() => {
                            setEditingInvitation(null);
                            setEditEmail("");
                            setTypoWarning(null);
                          }}
                        >
                          Annuler
                        </Button>
                      </div>
                      {/* Avertissement faute de frappe */}
                      {typoWarning && editingInvitation?.id === invitation.id && (
                        <div className="p-3 bg-yellow-50 dark:bg-yellow-950 border border-yellow-200 dark:border-yellow-800 rounded-lg">
                          <p className="text-sm text-yellow-800 dark:text-yellow-200 mb-2">
                            <AlertCircle className="h-4 w-4 inline mr-1" />
                            Faute de frappe détectée : <strong>{typoWarning.email}</strong>
                          </p>
                          <p className="text-sm text-yellow-700 dark:text-yellow-300 mb-3">
                            Vouliez-vous dire <strong>{typoWarning.suggestion}</strong> ?
                          </p>
                          <div className="flex gap-2">
                            <Button 
                              size="sm" 
                              onClick={() => confirmTypoAndSend(invitation)}
                            >
                              Utiliser {typoWarning.suggestion}
                            </Button>
                            <Button 
                              size="sm" 
                              variant="outline"
                              onClick={() => ignoreTypoAndSend(invitation, typoWarning.email)}
                            >
                              Garder {typoWarning.email}
                            </Button>
                          </div>
                        </div>
                      )}
                    </div>
                  ) : (
                    // Mode affichage
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        {status === "pending" && <Clock className="h-4 w-4 text-yellow-500" />}
                        {status === "expired" && <AlertCircle className="h-4 w-4 text-destructive" />}
                        {status === "accepted" && <CheckCircle className="h-4 w-4 text-green-500" />}
                        <div>
                          <p className="text-sm font-medium">{invitation.parent_email}</p>
                          <p className="text-xs text-muted-foreground">
                            {status === "pending" && `Expire le ${new Date(invitation.expires_at).toLocaleDateString("fr-FR")}`}
                            {status === "expired" && "Expirée"}
                            {status === "accepted" && "Acceptée"}
                          </p>
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <Badge 
                          variant={status === "pending" ? "secondary" : status === "expired" ? "destructive" : "default"}
                        >
                          {status === "pending" && "En attente"}
                          {status === "expired" && "Expirée"}
                          {status === "accepted" && "Acceptée"}
                        </Badge>
                        {/* Bouton Modifier pour pending et expired */}
                        {status !== "accepted" && (
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => {
                              setEditingInvitation(invitation);
                              setEditEmail(invitation.parent_email);
                            }}
                            disabled={sending}
                          >
                            <Pencil className="h-4 w-4 mr-1" />
                            Modifier
                          </Button>
                        )}
                        {status === "expired" && (
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => resendInvitation(invitation)}
                            disabled={sending}
                          >
                            <RefreshCw className={`h-4 w-4 mr-1 ${sending ? "animate-spin" : ""}`} />
                            Renvoyer
                          </Button>
                        )}
                        {status !== "accepted" && (
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => deleteInvitation(invitation.id)}
                          >
                            <Trash2 className="h-4 w-4 text-muted-foreground" />
                          </Button>
                        )}
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}

        {/* Add new invitation */}
        {canAddMore && (
          <div className="pt-4 border-t">
            {showAddForm ? (
              <div className="space-y-3">
                <Label htmlFor="parent-email">Email du parent</Label>
                <div className="flex gap-2">
                  <Input
                    id="parent-email"
                    type="email"
                    placeholder="parent@email.com"
                    value={newEmail}
                    onChange={(e) => setNewEmail(e.target.value)}
                  />
                  <Button onClick={sendNewInvitation} disabled={sending || !newEmail.trim()}>
                    <Mail className="h-4 w-4 mr-2" />
                    Envoyer
                  </Button>
                  <Button variant="outline" onClick={() => setShowAddForm(false)}>
                    Annuler
                  </Button>
                </div>
              </div>
            ) : (
              <Button variant="outline" onClick={() => setShowAddForm(true)}>
                <Plus className="h-4 w-4 mr-2" />
                Inviter un parent
              </Button>
            )}
          </div>
        )}

        {!canAddMore && invitations.length === 0 && parentRelations.length === 0 && (
          <p className="text-sm text-muted-foreground text-center py-4">
            Aucun parent lié pour le moment.
          </p>
        )}
      </CardContent>
    </Card>
  );
};
