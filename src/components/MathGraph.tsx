import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, ReferenceLine } from 'recharts';
import { evaluate } from 'mathjs';

interface MathGraphProps {
  expression: string;
  xMin?: number;
  xMax?: number;
  title?: string;
  gridColor?: string;
  lineColor?: string;
}

export const MathGraph = ({ 
  expression, 
  xMin = -10, 
  xMax = 10, 
  title,
  gridColor = "hsl(var(--border))",
  lineColor = "hsl(var(--primary))"
}: MathGraphProps) => {
  // Generate data points
  const generateData = () => {
    const points = [];
    const step = (xMax - xMin) / 200;
    
    try {
      for (let x = xMin; x <= xMax; x += step) {
        try {
          const y = evaluate(expression, { x });
          if (typeof y === 'number' && isFinite(y)) {
            points.push({ x: parseFloat(x.toFixed(3)), y: parseFloat(y.toFixed(3)) });
          }
        } catch {
          // Skip invalid points
        }
      }
    } catch (error) {
      console.error("Error generating graph data:", error);
    }
    
    return points;
  };

  const data = generateData();

  // Calculate Y domain that includes 0
  let yMin = 0;
  let yMax = 0;
  if (data.length > 0) {
    yMin = Math.min(...data.map(d => d.y), 0);
    yMax = Math.max(...data.map(d => d.y), 0);
    
    // Add symmetric margin
    const yRange = Math.max(Math.abs(yMin), Math.abs(yMax));
    const margin = yRange * 0.1; // 10% margin
    yMin = Math.min(yMin, -margin);
    yMax = Math.max(yMax, margin);
  }

  if (data.length === 0) {
    return (
      <div className="p-4 border rounded-lg bg-muted/50">
        <p className="text-sm text-muted-foreground">
          Impossible de tracer la fonction : {expression}
        </p>
      </div>
    );
  }

  return (
    <div className="w-full space-y-2">
      {title && (
        <h3 className="text-lg font-semibold text-center">{title}</h3>
      )}
      <ResponsiveContainer width="100%" height={400}>
        <LineChart data={data} margin={{ top: 5, right: 20, bottom: 20, left: 0 }}>
          <CartesianGrid strokeDasharray="3 3" stroke={gridColor} />
          <ReferenceLine x={0} stroke="hsl(var(--foreground))" strokeWidth={1.5} opacity={0.5} />
          <ReferenceLine y={0} stroke="hsl(var(--foreground))" strokeWidth={1.5} opacity={0.5} />
          <XAxis 
            dataKey="x" 
            type="number" 
            domain={[xMin, xMax]}
            label={{ value: 'x', position: 'insideBottomRight', offset: -10 }}
          />
          <YAxis 
            domain={[yMin, yMax]}
            label={{ value: 'y', angle: -90, position: 'insideLeft' }}
          />
          <Tooltip 
            contentStyle={{ 
              backgroundColor: 'hsl(var(--background))',
              border: '1px solid hsl(var(--border))',
              borderRadius: '6px'
            }}
            formatter={(value: number) => value.toFixed(3)}
          />
          <Line 
            type="monotone" 
            dataKey="y" 
            stroke={lineColor}
            strokeWidth={2}
            dot={false}
            isAnimationActive={false}
          />
        </LineChart>
      </ResponsiveContainer>
      <p className="text-xs text-center text-muted-foreground">
        f(x) = {expression}
      </p>
    </div>
  );
};
