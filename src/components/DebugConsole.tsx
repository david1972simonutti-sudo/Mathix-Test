import { useState } from "react";
import { ChevronDown, ChevronUp, Copy, Check, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";

export interface DebugEntry {
  timestamp: Date;
  type: "request" | "response";
  data: any;
}

interface DebugConsoleProps {
  entries: DebugEntry[];
  onClear?: () => void;
}

export const DebugConsole = ({ entries, onClear }: DebugConsoleProps) => {
  const [isOpen, setIsOpen] = useState(true);
  const [copiedIndex, setCopiedIndex] = useState<number | null>(null);

  const copyToClipboard = async (text: string, index: number) => {
    await navigator.clipboard.writeText(text);
    setCopiedIndex(index);
    setTimeout(() => setCopiedIndex(null), 2000);
  };

  // Extract the actual response content for analysis
  const getResponseContent = (data: any): string => {
    if (data?.response) return String(data.response);
    if (data?.rawData?.data) return String(data.rawData.data);
    if (typeof data === "string") return data;
    return JSON.stringify(data);
  };

  return (
    <div className="fixed bottom-4 right-4 w-[600px] max-w-[90vw] bg-slate-900 border border-slate-700 rounded-lg shadow-2xl z-50 overflow-hidden">
      {/* Header */}
      <div
        className="bg-slate-800 px-4 py-2 flex items-center justify-between cursor-pointer"
        onClick={() => setIsOpen(!isOpen)}
      >
        <div className="flex items-center gap-2">
          <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
          <span className="font-mono text-sm text-slate-200 font-semibold">
            🐛 Debug Console - Réponses Gemini
          </span>
          <span className="text-xs text-slate-400">({entries.length} entrées)</span>
        </div>
        <div className="flex items-center gap-2">
          {onClear && entries.length > 0 && (
            <Button
              variant="ghost"
              size="sm"
              className="h-6 w-6 p-0"
              onClick={(e) => {
                e.stopPropagation();
                onClear();
              }}
            >
              <Trash2 className="w-3 h-3 text-slate-400 hover:text-red-400" />
            </Button>
          )}
          {isOpen ? (
            <ChevronDown className="w-4 h-4 text-slate-400" />
          ) : (
            <ChevronUp className="w-4 h-4 text-slate-400" />
          )}
        </div>
      </div>

      {/* Content */}
      {isOpen && (
        <ScrollArea className="h-[500px]">
          <div className="p-4 space-y-3">
            {entries.length === 0 ? (
              <div className="text-center text-slate-400 text-sm py-8">
                Aucune requête pour le moment...
              </div>
            ) : (
              entries.map((entry, index) => {
                const responseContent = entry.type === "response" ? getResponseContent(entry.data) : "";
                
                return (
                  <div
                    key={index}
                    className={`rounded-lg border p-3 ${
                      entry.type === "request"
                        ? "bg-blue-950/30 border-blue-800"
                        : "bg-green-950/30 border-green-800"
                    }`}
                  >
                    {/* Entry header */}
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <span
                          className={`text-xs font-mono font-semibold ${
                            entry.type === "request" ? "text-blue-400" : "text-green-400"
                          }`}
                        >
                          {entry.type === "request" ? "📤 REQUEST" : "📥 RESPONSE"}
                        </span>
                        <span className="text-xs text-slate-400">
                          {entry.timestamp.toLocaleTimeString("fr-FR")}
                        </span>
                      </div>
                      <Button
                        variant="ghost"
                        size="sm"
                        className="h-6 w-6 p-0"
                        onClick={() =>
                          copyToClipboard(JSON.stringify(entry.data, null, 2), index)
                        }
                      >
                        {copiedIndex === index ? (
                          <Check className="w-3 h-3 text-green-400" />
                        ) : (
                          <Copy className="w-3 h-3 text-slate-400" />
                        )}
                      </Button>
                    </div>

                    {/* Entry content */}
                    <div className="font-mono text-xs text-slate-300 bg-slate-950/50 rounded p-2 overflow-x-auto max-h-[300px] overflow-y-auto">
                      <pre className="whitespace-pre-wrap break-words">
                        {JSON.stringify(entry.data, null, 2)}
                      </pre>
                    </div>

                    {/* LaTeX detection for responses */}
                    {entry.type === "response" && responseContent && (
                      <div className="mt-2 pt-2 border-t border-slate-700">
                        <div className="text-xs text-slate-400 mb-1">
                          🔍 Analyse du contenu :
                        </div>
                        <div className="text-xs font-mono space-y-0.5">
                          {responseContent.includes("\\int") && (
                            <div className="text-amber-400">✓ Contient des intégrales (\\int)</div>
                          )}
                          {responseContent.includes("\\frac") && (
                            <div className="text-amber-400">✓ Contient des fractions (\\frac)</div>
                          )}
                          {responseContent.includes("$$") && (
                            <div className="text-amber-400">✓ Contient des blocs LaTeX display ($$)</div>
                          )}
                          {(responseContent.match(/\$/g) || []).length > 0 && (
                            <div className="text-amber-400">✓ Contient du LaTeX inline ($) - {(responseContent.match(/\$/g) || []).length} occurrences</div>
                          )}
                          {responseContent.includes("```") && (
                            <div className="text-amber-400">✓ Contient des blocs de code (```)</div>
                          )}
                          {responseContent.includes("**") && (
                            <div className="text-amber-400">✓ Contient du gras markdown (**)</div>
                          )}
                          {responseContent.includes("###") && (
                            <div className="text-amber-400">✓ Contient des titres markdown (###)</div>
                          )}
                          {responseContent.includes("\\n") && (
                            <div className="text-orange-400">⚠️ Contient des \\n échappés (problème potentiel)</div>
                          )}
                          {!responseContent.includes("$") && !responseContent.includes("\\") && (
                            <div className="text-slate-500">✗ Pas de LaTeX détecté</div>
                          )}
                        </div>
                      </div>
                    )}
                  </div>
                );
              })
            )}
          </div>
        </ScrollArea>
      )}
    </div>
  );
};
