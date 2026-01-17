export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      bo_premiere: {
        Row: {
          chapitre: string
          created_at: string | null
          id: string
          sous_notion: string
        }
        Insert: {
          chapitre: string
          created_at?: string | null
          id?: string
          sous_notion: string
        }
        Update: {
          chapitre?: string
          created_at?: string | null
          id?: string
          sous_notion?: string
        }
        Relationships: []
      }
      bo_seconde: {
        Row: {
          chapitre: string
          created_at: string | null
          id: string
          sous_notion: string
        }
        Insert: {
          chapitre: string
          created_at?: string | null
          id?: string
          sous_notion: string
        }
        Update: {
          chapitre?: string
          created_at?: string | null
          id?: string
          sous_notion?: string
        }
        Relationships: []
      }
      bo_terminale: {
        Row: {
          chapitre: string
          created_at: string | null
          id: string
          sous_notion: string
        }
        Insert: {
          chapitre: string
          created_at?: string | null
          id?: string
          sous_notion: string
        }
        Update: {
          chapitre?: string
          created_at?: string | null
          id?: string
          sous_notion?: string
        }
        Relationships: []
      }
      chat_feedback: {
        Row: {
          comment: string | null
          conversation_id: string | null
          created_at: string | null
          id: string
          message_content: string | null
          message_id: string
          rating: string
          user_id: string
        }
        Insert: {
          comment?: string | null
          conversation_id?: string | null
          created_at?: string | null
          id?: string
          message_content?: string | null
          message_id: string
          rating: string
          user_id: string
        }
        Update: {
          comment?: string | null
          conversation_id?: string | null
          created_at?: string | null
          id?: string
          message_content?: string | null
          message_id?: string
          rating?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "chat_feedback_conversation_id_fkey"
            columns: ["conversation_id"]
            isOneToOne: false
            referencedRelation: "chats"
            referencedColumns: ["id"]
          },
        ]
      }
      chat_history: {
        Row: {
          chat_id: string | null
          content: string
          created_at: string
          id: string
          image_url: string | null
          role: string
          user_id: string
        }
        Insert: {
          chat_id?: string | null
          content: string
          created_at?: string
          id?: string
          image_url?: string | null
          role: string
          user_id: string
        }
        Update: {
          chat_id?: string | null
          content?: string
          created_at?: string
          id?: string
          image_url?: string | null
          role?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "chat_history_chat_id_fkey"
            columns: ["chat_id"]
            isOneToOne: false
            referencedRelation: "chats"
            referencedColumns: ["id"]
          },
        ]
      }
      chats: {
        Row: {
          chat_type: string | null
          created_at: string | null
          exercice_id: string | null
          exercise_context: Json | null
          id: string
          session_id: string | null
          titre: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          chat_type?: string | null
          created_at?: string | null
          exercice_id?: string | null
          exercise_context?: Json | null
          id?: string
          session_id?: string | null
          titre?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          chat_type?: string | null
          created_at?: string | null
          exercice_id?: string | null
          exercise_context?: Json | null
          id?: string
          session_id?: string | null
          titre?: string | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "chats_exercice_id_fkey"
            columns: ["exercice_id"]
            isOneToOne: true
            referencedRelation: "exercices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chats_session_id_fkey"
            columns: ["session_id"]
            isOneToOne: false
            referencedRelation: "sessions"
            referencedColumns: ["id"]
          },
        ]
      }
      competences_snapshots: {
        Row: {
          competences: Json
          created_at: string | null
          id: string
          snapshot_date: string
          user_id: string
        }
        Insert: {
          competences?: Json
          created_at?: string | null
          id?: string
          snapshot_date?: string
          user_id: string
        }
        Update: {
          competences?: Json
          created_at?: string | null
          id?: string
          snapshot_date?: string
          user_id?: string
        }
        Relationships: []
      }
      email_confirmations: {
        Row: {
          confirmed_at: string | null
          created_at: string
          email: string
          expires_at: string
          id: string
          token: string
          user_id: string
        }
        Insert: {
          confirmed_at?: string | null
          created_at?: string
          email: string
          expires_at?: string
          id?: string
          token?: string
          user_id: string
        }
        Update: {
          confirmed_at?: string | null
          created_at?: string
          email?: string
          expires_at?: string
          id?: string
          token?: string
          user_id?: string
        }
        Relationships: []
      }
      exercices: {
        Row: {
          chapitre: string
          content_hash: string | null
          created_at: string | null
          enonce: string
          id: string
          indices: Json | null
          niveau: string
          params: Json | null
          solution: string
        }
        Insert: {
          chapitre: string
          content_hash?: string | null
          created_at?: string | null
          enonce: string
          id?: string
          indices?: Json | null
          niveau: string
          params?: Json | null
          solution: string
        }
        Update: {
          chapitre?: string
          content_hash?: string | null
          created_at?: string | null
          enonce?: string
          id?: string
          indices?: Json | null
          niveau?: string
          params?: Json | null
          solution?: string
        }
        Relationships: []
      }
      hors_programme_classe: {
        Row: {
          classe: string
          created_at: string | null
          id: string
          niveau_cible: string
          notion: string
        }
        Insert: {
          classe: string
          created_at?: string | null
          id?: string
          niveau_cible: string
          notion: string
        }
        Update: {
          classe?: string
          created_at?: string | null
          id?: string
          niveau_cible?: string
          notion?: string
        }
        Relationships: []
      }
      interactions: {
        Row: {
          analyse_erreur: Json | null
          chapitre: string | null
          chat_id: string | null
          chat_type: string | null
          correction: string | null
          created_at: string | null
          duree_interaction: number | null
          exercice_enonce: string | null
          exercice_id: string | null
          id: string
          image_url: string | null
          modele_utilise: string | null
          reponse_eleve: string | null
          satisfaction_eleve: number | null
          session_id: string | null
          tokens_utilises: number | null
          user_id: string
        }
        Insert: {
          analyse_erreur?: Json | null
          chapitre?: string | null
          chat_id?: string | null
          chat_type?: string | null
          correction?: string | null
          created_at?: string | null
          duree_interaction?: number | null
          exercice_enonce?: string | null
          exercice_id?: string | null
          id?: string
          image_url?: string | null
          modele_utilise?: string | null
          reponse_eleve?: string | null
          satisfaction_eleve?: number | null
          session_id?: string | null
          tokens_utilises?: number | null
          user_id: string
        }
        Update: {
          analyse_erreur?: Json | null
          chapitre?: string | null
          chat_id?: string | null
          chat_type?: string | null
          correction?: string | null
          created_at?: string | null
          duree_interaction?: number | null
          exercice_enonce?: string | null
          exercice_id?: string | null
          id?: string
          image_url?: string | null
          modele_utilise?: string | null
          reponse_eleve?: string | null
          satisfaction_eleve?: number | null
          session_id?: string | null
          tokens_utilises?: number | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "interactions_chat_id_fkey"
            columns: ["chat_id"]
            isOneToOne: false
            referencedRelation: "chats"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "interactions_exercice_id_fkey"
            columns: ["exercice_id"]
            isOneToOne: false
            referencedRelation: "exercices"
            referencedColumns: ["id"]
          },
        ]
      }
      interventions_pedagogiques: {
        Row: {
          chapitre_actuel: string
          created_at: string | null
          explication: string | null
          gravite: number | null
          id: string
          interaction_id: string | null
          message_affiche: string | null
          mode_aide_renforcee: boolean | null
          nb_nouvelles_erreurs_apres_refus: number | null
          niveau: string
          niveau_prerequis: string | null
          notion_actuelle: string
          prerequis_manquant: string
          recommandation_action: string | null
          statut: string | null
          type_erreur: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          chapitre_actuel: string
          created_at?: string | null
          explication?: string | null
          gravite?: number | null
          id?: string
          interaction_id?: string | null
          message_affiche?: string | null
          mode_aide_renforcee?: boolean | null
          nb_nouvelles_erreurs_apres_refus?: number | null
          niveau: string
          niveau_prerequis?: string | null
          notion_actuelle: string
          prerequis_manquant: string
          recommandation_action?: string | null
          statut?: string | null
          type_erreur?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          chapitre_actuel?: string
          created_at?: string | null
          explication?: string | null
          gravite?: number | null
          id?: string
          interaction_id?: string | null
          message_affiche?: string | null
          mode_aide_renforcee?: boolean | null
          nb_nouvelles_erreurs_apres_refus?: number | null
          niveau?: string
          niveau_prerequis?: string | null
          notion_actuelle?: string
          prerequis_manquant?: string
          recommandation_action?: string | null
          statut?: string | null
          type_erreur?: string | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "interventions_pedagogiques_interaction_id_fkey"
            columns: ["interaction_id"]
            isOneToOne: false
            referencedRelation: "interactions"
            referencedColumns: ["id"]
          },
        ]
      }
      parent_eleve_relations: {
        Row: {
          created_at: string | null
          eleve_user_id: string
          id: string
          parent_user_id: string
        }
        Insert: {
          created_at?: string | null
          eleve_user_id: string
          id?: string
          parent_user_id: string
        }
        Update: {
          created_at?: string | null
          eleve_user_id?: string
          id?: string
          parent_user_id?: string
        }
        Relationships: []
      }
      parent_invitations: {
        Row: {
          created_at: string | null
          eleve_user_id: string
          expires_at: string | null
          id: string
          parent_email: string
          status: string | null
          token: string
        }
        Insert: {
          created_at?: string | null
          eleve_user_id: string
          expires_at?: string | null
          id?: string
          parent_email: string
          status?: string | null
          token?: string
        }
        Update: {
          created_at?: string | null
          eleve_user_id?: string
          expires_at?: string | null
          id?: string
          parent_email?: string
          status?: string | null
          token?: string
        }
        Relationships: []
      }
      password_reset_tokens: {
        Row: {
          created_at: string | null
          email: string
          expires_at: string | null
          id: string
          token: string
          used_at: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          email: string
          expires_at?: string | null
          id?: string
          token?: string
          used_at?: string | null
          user_id: string
        }
        Update: {
          created_at?: string | null
          email?: string
          expires_at?: string | null
          id?: string
          token?: string
          used_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      pending_signups: {
        Row: {
          created_at: string | null
          encrypted_data: string
          expires_at: string | null
          id: string
          parent_emails_encrypted: string | null
          reception_news: boolean | null
          token: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          encrypted_data: string
          expires_at?: string | null
          id?: string
          parent_emails_encrypted?: string | null
          reception_news?: boolean | null
          token?: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          encrypted_data?: string
          expires_at?: string | null
          id?: string
          parent_emails_encrypted?: string | null
          reception_news?: boolean | null
          token?: string
          user_id?: string
        }
        Relationships: []
      }
      profiles: {
        Row: {
          classe: string
          created_at: string | null
          date_paiement: string | null
          email: string
          has_seen_welcome_popup: boolean | null
          id: string
          nom: string
          paiement_valide: boolean | null
          premiere_utilisation_chat: string | null
          prenom: string
          reception_news: boolean | null
          user_id: string
        }
        Insert: {
          classe: string
          created_at?: string | null
          date_paiement?: string | null
          email: string
          has_seen_welcome_popup?: boolean | null
          id?: string
          nom: string
          paiement_valide?: boolean | null
          premiere_utilisation_chat?: string | null
          prenom: string
          reception_news?: boolean | null
          user_id: string
        }
        Update: {
          classe?: string
          created_at?: string | null
          date_paiement?: string | null
          email?: string
          has_seen_welcome_popup?: boolean | null
          id?: string
          nom?: string
          paiement_valide?: boolean | null
          premiere_utilisation_chat?: string | null
          prenom?: string
          reception_news?: boolean | null
          user_id?: string
        }
        Relationships: []
      }
      sessions: {
        Row: {
          date_debut: string | null
          date_fin: string | null
          duree_totale: number | null
          humeur_du_jour: string | null
          humeur_timestamp: string | null
          id: string
          nb_exercices: number | null
          progression: Json | null
          user_id: string
        }
        Insert: {
          date_debut?: string | null
          date_fin?: string | null
          duree_totale?: number | null
          humeur_du_jour?: string | null
          humeur_timestamp?: string | null
          id?: string
          nb_exercices?: number | null
          progression?: Json | null
          user_id: string
        }
        Update: {
          date_debut?: string | null
          date_fin?: string | null
          duree_totale?: number | null
          humeur_du_jour?: string | null
          humeur_timestamp?: string | null
          id?: string
          nb_exercices?: number | null
          progression?: Json | null
          user_id?: string
        }
        Relationships: []
      }
      student_profiles: {
        Row: {
          competences: Json | null
          id: string
          lacunes_identifiees: Json | null
          recent_cours_context: Json | null
          style_apprentissage: string | null
          updated_at: string | null
          user_id: string
        }
        Insert: {
          competences?: Json | null
          id?: string
          lacunes_identifiees?: Json | null
          recent_cours_context?: Json | null
          style_apprentissage?: string | null
          updated_at?: string | null
          user_id: string
        }
        Update: {
          competences?: Json | null
          id?: string
          lacunes_identifiees?: Json | null
          recent_cours_context?: Json | null
          style_apprentissage?: string | null
          updated_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      user_feedback: {
        Row: {
          comment: string | null
          created_at: string | null
          csat_score: number
          difficulty: string | null
          id: string
          user_id: string
        }
        Insert: {
          comment?: string | null
          created_at?: string | null
          csat_score: number
          difficulty?: string | null
          id?: string
          user_id: string
        }
        Update: {
          comment?: string | null
          created_at?: string | null
          csat_score?: number
          difficulty?: string | null
          id?: string
          user_id?: string
        }
        Relationships: []
      }
      user_roles: {
        Row: {
          created_at: string | null
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
    }
    Enums: {
      app_role: "eleve" | "parent" | "administrateur"
      groupe_test: "gemini" | "o4mini"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      app_role: ["eleve", "parent", "administrateur"],
      groupe_test: ["gemini", "o4mini"],
    },
  },
} as const
