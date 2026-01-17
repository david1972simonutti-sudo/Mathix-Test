import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Bug, X, Trash2 } from 'lucide-react';

interface LogEntry {
  id: string;
  timestamp: Date;
  type: 'request' | 'response' | 'error';
  functionName: string;
  data: any;
}

interface DebugPanelProps {
  logs: LogEntry[];
  onClear: () => void;
}

export function useDebugLogger() {
  const [logs, setLogs] = useState<LogEntry[]>([]);

  const logRequest = (functionName: string, data: any) => {
    setLogs(prev => [...prev, {
      id: crypto.randomUUID(),
      timestamp: new Date(),
      type: 'request',
      functionName,
      data
    }]);
  };

  const logResponse = (functionName: string, data: any) => {
    setLogs(prev => [...prev, {
      id: crypto.randomUUID(),
      timestamp: new Date(),
      type: 'response',
      functionName,
      data
    }]);
  };

  const logError = (functionName: string, error: any) => {
    setLogs(prev => [...prev, {
      id: crypto.randomUUID(),
      timestamp: new Date(),
      type: 'error',
      functionName,
      data: error
    }]);
  };

  const clearLogs = () => setLogs([]);

  return { logs, logRequest, logResponse, logError, clearLogs };
}

function JsonDisplay({ data }: { data: any }) {
  const jsonString = JSON.stringify(data, null, 2);
  
  return (
    <pre className="bg-muted p-3 rounded-md text-xs overflow-x-auto font-mono">
      <code>{jsonString}</code>
    </pre>
  );
}

function NewFieldsHighlight({ nouveauxChamps }: { nouveauxChamps: any[] }) {
  if (!nouveauxChamps || nouveauxChamps.length === 0) {
    return <div className="text-muted-foreground text-sm">Aucun nouveau champ détecté</div>;
  }

  return (
    <div className="space-y-2">
      <div className="font-bold text-sm bg-gradient-to-r from-math-primary to-math-accent bg-clip-text text-transparent">
        ⭐ NOUVEAUX CHAMPS DÉTECTÉS (Étape 2):
      </div>
      {nouveauxChamps.map((item, idx) => (
        <div key={idx} className="bg-math-primary/10 p-3 rounded-md border border-math-primary/20 space-y-1">
          <div className="text-xs font-semibold text-math-primary">Notion: {item.sous_notion}</div>
          <div className="grid grid-cols-2 gap-2 text-xs">
            <div>
              <span className="font-medium">Gravité:</span> {item.gravite_intrinsèque ?? 'N/A'}
            </div>
            <div>
              <span className="font-medium">Niveau attendu:</span> {item.niveau_attendu ?? 'N/A'}
            </div>
            <div>
              <span className="font-medium">Type erreur:</span> {item.type_erreur ?? 'N/A'}
            </div>
            <div>
              <span className="font-medium">Pré-requis manquant:</span>{' '}
              {item.est_prerequis_manquant ? (
                <span className="text-destructive font-bold">✅ OUI</span>
              ) : (
                <span className="text-muted-foreground">Non</span>
              )}
            </div>
            {item.prerequis_identifie && (
              <>
                <div className="col-span-2">
                  <span className="font-medium">Pré-requis identifié:</span> {item.prerequis_identifie}
                </div>
                <div>
                  <span className="font-medium">Niveau pré-requis:</span> {item.niveau_attendu_prerequis ?? 'N/A'}
                </div>
                <div>
                  <span className="font-medium">Bloque progression:</span>{' '}
                  {item.bloque_progression ? (
                    <span className="text-destructive">Oui</span>
                  ) : (
                    <span className="text-muted-foreground">Non</span>
                  )}
                </div>
              </>
            )}
          </div>
        </div>
      ))}
    </div>
  );
}

function LogEntryDisplay({ log }: { log: LogEntry }) {
  const timeString = log.timestamp.toLocaleTimeString('fr-FR', {
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  });

  const getTypeIcon = () => {
    switch (log.type) {
      case 'request': return '📤';
      case 'response': return '📥';
      case 'error': return '❌';
    }
  };

  const getTypeColor = () => {
    switch (log.type) {
      case 'request': return 'border-blue-500 bg-blue-50 dark:bg-blue-950/20';
      case 'response': return 'border-green-500 bg-green-50 dark:bg-green-950/20';
      case 'error': return 'border-destructive bg-destructive/10';
    }
  };

  return (
    <div className={`border-l-4 p-3 rounded ${getTypeColor()} space-y-2`}>
      <div className="flex justify-between items-start">
        <div>
          <div className="font-semibold text-sm">
            {getTypeIcon()} {log.type.toUpperCase()} - {log.functionName}
          </div>
          <div className="text-xs text-muted-foreground">⏱️ {timeString}</div>
        </div>
      </div>

      {log.type === 'response' && log.data?.nouveauxChamps && (
        <NewFieldsHighlight nouveauxChamps={log.data.nouveauxChamps} />
      )}

      <details className="text-xs">
        <summary className="cursor-pointer font-medium hover:text-math-primary">
          Voir les données complètes
        </summary>
        <div className="mt-2">
          <JsonDisplay data={log.data} />
        </div>
      </details>
    </div>
  );
}

export function DebugPanel({ logs, onClear }: DebugPanelProps) {
  const [isOpen, setIsOpen] = useState(false);

  const requestLogs = logs.filter(log => log.type === 'request');
  const responseLogs = logs.filter(log => log.type === 'response');
  const errorLogs = logs.filter(log => log.type === 'error');

  if (!isOpen) {
    return (
      <Button
        onClick={() => setIsOpen(true)}
        variant="outline"
        size="sm"
        className="fixed bottom-4 right-4 z-50 shadow-lg border-math-primary/50 hover:border-math-primary"
      >
        <Bug className="w-4 h-4 mr-2" />
        Debug ({logs.length})
      </Button>
    );
  }

  return (
    <Card className="fixed bottom-4 right-4 z-50 w-[700px] max-h-[80vh] shadow-2xl border-math-primary/50">
      <div className="flex justify-between items-center p-4 border-b">
        <h3 className="font-bold text-lg flex items-center gap-2">
          <Bug className="w-5 h-5 text-math-primary" />
          Debug Panel
        </h3>
        <div className="flex gap-2">
          <Button
            onClick={onClear}
            variant="ghost"
            size="sm"
            disabled={logs.length === 0}
          >
            <Trash2 className="w-4 h-4 mr-1" />
            Clear
          </Button>
          <Button
            onClick={() => setIsOpen(false)}
            variant="ghost"
            size="sm"
          >
            <X className="w-4 h-4" />
          </Button>
        </div>
      </div>

      <Tabs defaultValue="responses" className="w-full">
        <TabsList className="w-full grid grid-cols-3 p-4">
          <TabsTrigger value="requests" className="text-xs">
            Requests ({requestLogs.length})
          </TabsTrigger>
          <TabsTrigger value="responses" className="text-xs">
            Responses ({responseLogs.length})
          </TabsTrigger>
          <TabsTrigger value="errors" className="text-xs">
            Errors ({errorLogs.length})
          </TabsTrigger>
        </TabsList>

        <ScrollArea className="h-[60vh]">
          <TabsContent value="requests" className="p-4 space-y-3">
            {requestLogs.length === 0 ? (
              <div className="text-center text-muted-foreground py-8">
                Aucune requête enregistrée
              </div>
            ) : (
              requestLogs.map(log => <LogEntryDisplay key={log.id} log={log} />)
            )}
          </TabsContent>

          <TabsContent value="responses" className="p-4 space-y-3">
            {responseLogs.length === 0 ? (
              <div className="text-center text-muted-foreground py-8">
                Aucune réponse enregistrée
              </div>
            ) : (
              responseLogs.map(log => <LogEntryDisplay key={log.id} log={log} />)
            )}
          </TabsContent>

          <TabsContent value="errors" className="p-4 space-y-3">
            {errorLogs.length === 0 ? (
              <div className="text-center text-muted-foreground py-8">
                Aucune erreur enregistrée
              </div>
            ) : (
              errorLogs.map(log => <LogEntryDisplay key={log.id} log={log} />)
            )}
          </TabsContent>
        </ScrollArea>
      </Tabs>

      <div className="p-3 bg-muted/50 text-xs border-t">
        <strong>💡 Utilisation:</strong> Ce panneau permet de valider l'étape 2 en visualisant les nouveaux champs retournés par Gemini.
      </div>
    </Card>
  );
}
