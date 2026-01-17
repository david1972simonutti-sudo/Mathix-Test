import { RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, ResponsiveContainer } from 'recharts';

interface TransversaleData {
  score_actuel: number;
  total_sollicitations: number;
  interactions: Array<{
    date: string;
    niveau: string;
    index: number;
  }>;
}

interface CompetencesRadarProps {
  transversales: {
    chercher?: TransversaleData;
    modeliser?: TransversaleData;
    representer?: TransversaleData;
    raisonner?: TransversaleData;
    calculer?: TransversaleData;
    communiquer?: TransversaleData;
  };
}

const CompetencesRadar = ({ transversales }: CompetencesRadarProps) => {
  const data = [
    { 
      competence: 'Chercher', 
      score: (transversales.chercher?.score_actuel ?? 0.5) * 100, 
      count: transversales.chercher?.total_sollicitations || 0 
    },
    { 
      competence: 'Modéliser', 
      score: (transversales.modeliser?.score_actuel ?? 0.5) * 100, 
      count: transversales.modeliser?.total_sollicitations || 0 
    },
    { 
      competence: 'Représenter', 
      score: (transversales.representer?.score_actuel ?? 0.5) * 100, 
      count: transversales.representer?.total_sollicitations || 0 
    },
    { 
      competence: 'Raisonner', 
      score: (transversales.raisonner?.score_actuel ?? 0.5) * 100, 
      count: transversales.raisonner?.total_sollicitations || 0 
    },
    { 
      competence: 'Calculer', 
      score: (transversales.calculer?.score_actuel ?? 0.5) * 100, 
      count: transversales.calculer?.total_sollicitations || 0 
    },
    { 
      competence: 'Communiquer', 
      score: (transversales.communiquer?.score_actuel ?? 0.5) * 100, 
      count: transversales.communiquer?.total_sollicitations || 0 
    },
  ];

  // Déterminer la couleur selon le score
  const getColor = (score: number) => {
    if (score >= 75) return "#22c55e"; // Vert
    if (score >= 50) return "#06b6d4"; // Cyan
    return "#ef4444"; // Rouge
  };

  return (
    <div className="space-y-6">
      <div className="bg-card border border-border rounded-lg p-6">
        <h3 className="text-xl font-bold mb-4 text-center">6 Grandes Compétences Mathématiques</h3>
        
        <ResponsiveContainer width="100%" height={400}>
          <RadarChart data={data}>
            <PolarGrid stroke="#6b7280" />
            <PolarAngleAxis 
              dataKey="competence" 
              tick={{ fill: 'currentColor', fontSize: 14, fontWeight: 600, dy: -5 }}
            />
            <PolarRadiusAxis 
              angle={90} 
              domain={[0, 100]} 
              tick={{ fill: '#6b7280' }}
            />
            <Radar 
              name="Score de maîtrise" 
              dataKey="score" 
              stroke="#8b5cf6" 
              fill="#8b5cf6"
              fillOpacity={0.4}
              isAnimationActive={false}
            />
          </RadarChart>
        </ResponsiveContainer>

        {/* Légende avec compteurs */}
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4 mt-6">
          {data.map((item) => (
            <div key={item.competence} className="flex flex-col items-center p-3 bg-muted/50 rounded-lg">
              <span className="font-medium text-sm">{item.competence}</span>
              <span className="text-2xl font-bold" style={{ color: getColor(item.score) }}>
                {Math.round(item.score)}%
              </span>
              <span className="text-xs text-muted-foreground">
                {item.count} {item.count > 1 ? 'sollicitations' : 'sollicitation'}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Légende explicative */}
      <div className="bg-muted/30 border border-border rounded-lg p-4 text-sm">
        <h4 className="font-semibold mb-2">📊 Comment lire ce graphique ?</h4>
        <ul className="space-y-1 text-muted-foreground">
          <li>• <strong>Plus le score est élevé</strong>, plus tu maîtrises cette compétence</li>
          <li>• Les scores sont calculés avec <strong>récence</strong> : tes derniers exercices comptent plus</li>
          <li>• Le nombre de sollicitations indique combien de fois tu as mobilisé cette compétence</li>
        </ul>
      </div>
    </div>
  );
};

export default CompetencesRadar;
