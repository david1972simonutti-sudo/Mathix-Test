import { MathText } from "@/components/MathText";
import { Badge } from "@/components/ui/badge";
import { normalizeChatText } from "@/utils/normalizeChatText";

interface ExerciseDisplayProps {
  parsedContent: {
    type?: string;
    message_introduction?: string;
    chapitre?: string;
    niveau?: string;
    enonce?: {
      contexte?: string;
      questions?: string[];
    } | string;
    indices?: string[];
    solution_complete?: string;
  };
  showSolution?: boolean;
  className?: string;
}

export const ExerciseDisplay = ({ 
  parsedContent, 
  showSolution = false,
  className = "" 
}: ExerciseDisplayProps) => {
  return (
    <div className={`space-y-4 ${className}`}>
      {/* Message d'introduction */}
      {parsedContent.message_introduction && (
        <MathText
          content={normalizeChatText(parsedContent.message_introduction)}
          mode="lenient"
          auto={{ functions: true, pi: true, sqrt: true, degrees: true, intervals: true }}
          className="text-foreground"
        />
      )}

      {/* Badge chapitre */}
      {parsedContent.chapitre && (
        <div className="flex items-center gap-2">
          <Badge variant="outline" className="text-xs">
            {parsedContent.chapitre}
          </Badge>
          {parsedContent.niveau && (
            <Badge variant="secondary" className="text-xs">
              {parsedContent.niveau}
            </Badge>
          )}
        </div>
      )}

      {/* Énoncé de l'exercice */}
      <div className="mt-4 p-4 bg-background/50 rounded-md border">
        <h3 className="text-lg font-semibold text-primary mb-4">
          📝 Énoncé
        </h3>

        {/* Contexte de l'exercice */}
        {typeof parsedContent.enonce === 'object' && parsedContent.enonce?.contexte && (
          <div className="mb-6 bg-muted/30 p-4 rounded-lg">
            <MathText
              content={normalizeChatText(parsedContent.enonce.contexte)}
              mode="lenient"
              auto={{
                functions: true,
                intervals: true,
                pi: true,
                sqrt: true,
                degrees: true,
                variables: true,
                greek: true,
              }}
              centerBlocks
              className="text-foreground [&>div]:my-4"
            />
          </div>
        )}

        {/* Questions séparées avec numérotation */}
        {typeof parsedContent.enonce === 'object' && 
         parsedContent.enonce?.questions && 
         parsedContent.enonce.questions.length > 0 ? (
          <div className="space-y-4">
            {parsedContent.enonce.questions.map((question: string, qIdx: number) => {
              // Nettoyer la numérotation en début de question (si l'IA l'a déjà incluse)
              const cleanQuestion = question.replace(/^\d+[\.\)]\s*/, '');
              return (
                <div 
                  key={qIdx} 
                  className="flex gap-3 items-start"
                >
                  <span className="font-bold text-primary shrink-0 text-lg">
                    {qIdx + 1}.
                  </span>
                  <MathText
                    content={normalizeChatText(cleanQuestion)}
                    mode="lenient"
                    auto={{
                      functions: true,
                      intervals: true,
                      pi: true,
                      sqrt: true,
                      degrees: true,
                      variables: true,
                      greek: true,
                    }}
                    className="text-foreground flex-1"
                  />
                </div>
              );
            })}
          </div>
        ) : (
          /* Si pas de questions séparées, afficher l'énoncé brut */
          typeof parsedContent.enonce === 'string' && (
            <MathText
              content={normalizeChatText(parsedContent.enonce)}
              mode="lenient"
              auto={{ 
                functions: true, 
                pi: true, 
                sqrt: true, 
                degrees: true, 
                intervals: true,
                variables: true,
                greek: true 
              }}
              className="text-foreground"
            />
          )
        )}
      </div>

      {/* Indices masqués - l'élève doit les demander via le chat */}

      {/* Solution (si demandée) */}
      {showSolution && parsedContent.solution_complete && (
        <div className="mt-4 p-4 bg-green-50 dark:bg-green-950/20 rounded-lg border border-green-200 dark:border-green-800">
          <h4 className="text-sm font-semibold text-green-900 dark:text-green-100 mb-3">
            ✅ Solution
          </h4>
          <MathText
            content={normalizeChatText(parsedContent.solution_complete)}
            mode="lenient"
            auto={{
              functions: true,
              intervals: true,
              pi: true,
              sqrt: true,
              degrees: true,
              variables: true,
              greek: true,
            }}
            centerBlocks
            className="text-foreground [&>div]:my-4"
          />
        </div>
      )}
    </div>
  );
};
