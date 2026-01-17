interface EmptyStateChatProps {
  onSuggestionClick: (message: string) => void;
}

export const EmptyStateChat = ({ onSuggestionClick }: EmptyStateChatProps) => (
  <div className="flex flex-col items-center justify-center h-full py-12 px-4">
    {/* Titre */}
    <h2 className="text-2xl font-bold text-gray-800 dark:text-gray-100 mb-2">
      Prêt à travailler ?
    </h2>
    
    {/* Sous-titre */}
    <p className="text-gray-500 dark:text-gray-400 text-center max-w-md">
      Pose ta question, envoie une photo ou choisis un sujet.
    </p>
  </div>
);
