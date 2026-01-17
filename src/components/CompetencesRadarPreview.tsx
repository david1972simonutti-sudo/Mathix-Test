import { RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, ResponsiveContainer } from 'recharts';

const CompetencesRadarPreview = () => {
  // Données de démo statiques
  const data = [
    { competence: 'Chercher', score: 72, count: 71 },
    { competence: 'Modéliser', score: 49, count: 50 },
    { competence: 'Représenter', score: 80, count: 23 },
    { competence: 'Raisonner', score: 58, count: 71 },
    { competence: 'Calculer', score: 92, count: 75 },
    { competence: 'Communiquer', score: 60, count: 64 },
  ];

  const getColor = (score: number) => {
    if (score >= 70) return '#22c55e'; // green-500
    if (score >= 50) return '#f97316'; // orange-500
    return '#ef4444'; // red-500
  };

  return (
    <div className="w-full p-4">
      {/* Titre */}
      <h3 className="text-center text-lg font-bold text-gray-800 mb-4">
        6 Grandes Compétences Mathématiques
      </h3>
      
      {/* Radar Chart */}
      <div className="h-72 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <RadarChart data={data} margin={{ top: 20, right: 40, bottom: 20, left: 40 }}>
            <PolarGrid stroke="#d1d5db" />
            <PolarAngleAxis 
              dataKey="competence" 
              tick={{ fill: '#374151', fontSize: 12, fontWeight: 600 }}
            />
            <PolarRadiusAxis 
              angle={90} 
              domain={[0, 100]} 
              tick={{ fill: '#6b7280', fontSize: 10 }}
              tickCount={5}
            />
            <Radar
              name="Score"
              dataKey="score"
              stroke="#8b5cf6"
              fill="#8b5cf6"
              fillOpacity={0.5}
              strokeWidth={2}
              isAnimationActive={false}
            />
          </RadarChart>
        </ResponsiveContainer>
      </div>
      
      {/* Grille des scores */}
      <div className="grid grid-cols-3 gap-3 mt-6">
        {data.map((item) => (
          <div 
            key={item.competence}
            className="bg-gray-50 rounded-xl p-3 text-center border border-gray-200"
          >
            <div className="text-sm text-gray-700 font-semibold mb-1">{item.competence}</div>
            <div 
              className="text-2xl font-bold"
              style={{ color: getColor(item.score) }}
            >
              {item.score}%
            </div>
            <div className="text-xs text-gray-500">{item.count} sollicitations</div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default CompetencesRadarPreview;
