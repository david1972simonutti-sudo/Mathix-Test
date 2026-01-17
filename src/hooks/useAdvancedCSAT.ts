import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import type { CSATData } from "@/components/LogoutCSATDialog";

interface UserProfile {
  prenom: string;
  nom: string;
  email: string;
  classe: string;
}

export function useAdvancedCSAT() {
  const [isCSATOpen, setIsCSATOpen] = useState(false);
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const navigate = useNavigate();
  const { toast } = useToast();

  const triggerLogoutWithCSAT = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        // User not logged in, just sign out
        await supabase.auth.signOut();
        navigate("/");
        return;
      }

      setUserId(user.id);

      // Fetch user profile
      const { data: profile, error } = await supabase
        .from("profiles")
        .select("prenom, nom, email, classe")
        .eq("user_id", user.id)
        .single();

      if (error) {
        console.error("Error fetching profile for CSAT:", error);
        // Still open dialog but without profile data
      }

      setUserProfile(profile || null);
      setIsCSATOpen(true);
    } catch (error) {
      console.error("Error in triggerLogoutWithCSAT:", error);
      // Fallback: just logout
      await supabase.auth.signOut();
      navigate("/");
    }
  };

  const handleCSATComplete = async (data?: CSATData) => {
    try {
      if (data && userProfile && userId) {
        // 1. Save to database
        const { error: insertError } = await supabase
          .from("user_feedback")
          .insert({
            user_id: userId,
            csat_score: data.csat,
            difficulty: data.difficulty || null,
            comment: data.comment || null,
          });

        if (insertError) {
          console.error("Error saving CSAT feedback:", insertError);
        }

        // 2. Send email to support@siimply.fr
        const { error: emailError } = await supabase.functions.invoke("send-email", {
          body: {
            type: "csat_feedback",
            userPrenom: userProfile.prenom,
            userNom: userProfile.nom,
            userEmail: userProfile.email,
            userClasse: userProfile.classe,
            csatScore: data.csat,
            difficulty: data.difficulty,
            comment: data.comment,
          },
        });

        if (emailError) {
          console.error("Error sending CSAT email:", emailError);
        }

        // 3. GA tracking if low CSAT
        if (data.csat < 3 && typeof window !== "undefined" && (window as any).gtag) {
          (window as any).gtag("event", "low_csat_logout", {
            csat_score: data.csat,
            difficulty: data.difficulty,
          });
        }

        // 4. Show toast if low CSAT
        if (data.csat === 1) {
          toast({
            title: "Désolé !",
            description: "N'hésite pas à contacter le support si tu as besoin d'aide.",
            variant: "destructive",
          });
        }
      }
    } catch (error) {
      console.error("Error in handleCSATComplete:", error);
    } finally {
      // Always logout
      await supabase.auth.signOut();
      setIsCSATOpen(false);
      navigate("/");
    }
  };

  const handleCSATSkip = async () => {
    await supabase.auth.signOut();
    setIsCSATOpen(false);
    navigate("/");
  };

  return {
    isCSATOpen,
    userProfile,
    userId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  };
}
