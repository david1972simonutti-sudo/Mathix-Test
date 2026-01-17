import { useEffect, useRef } from 'react';
import { supabase } from '@/integrations/supabase/client';

/**
 * Hook to track the first time a user uses the chat
 * Updates the premiere_utilisation_chat field in profiles
 */
export const useTrackFirstChatUse = (userId: string | undefined) => {
  const hasTrackedRef = useRef(false);

  const trackFirstMessage = async () => {
    if (!userId || hasTrackedRef.current) return;

    try {
      // Check if premiere_utilisation_chat is already set
      const { data: profile, error: fetchError } = await supabase
        .from('profiles')
        .select('premiere_utilisation_chat')
        .eq('user_id', userId)
        .single();

      if (fetchError) {
        console.error('Error checking first chat use:', fetchError);
        return;
      }

      // If already set, don't update
      if (profile?.premiere_utilisation_chat) {
        hasTrackedRef.current = true;
        return;
      }

      // Update with current timestamp
      const { error: updateError } = await supabase
        .from('profiles')
        .update({ premiere_utilisation_chat: new Date().toISOString() })
        .eq('user_id', userId);

      if (updateError) {
        console.error('Error updating first chat use:', updateError);
      } else {
        console.log('✅ First chat use tracked successfully');
        hasTrackedRef.current = true;
      }
    } catch (error) {
      console.error('Error in trackFirstMessage:', error);
    }
  };

  return { trackFirstMessage };
};
