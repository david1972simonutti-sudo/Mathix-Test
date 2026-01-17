interface MiniProgressBarProps {
  label: string;
  value: number | null; // 0-100 ou null si pas de données
}

export const MiniProgressBar = ({ label, value }: MiniProgressBarProps) => {
  const hasData = value !== null && value !== undefined;
  
  let color: string;
  if (!hasData) {
    color = "bg-muted";
  } else if (value >= 75) {
    color = "bg-green-500";
  } else if (value >= 50) {
    color = "bg-orange-400";
  } else {
    color = "bg-red-400";
  }

  return (
    <div className="flex items-center gap-2">
      <span className="text-xs text-muted-foreground w-20 truncate">{label}</span>
      <div className="flex-1 h-2 bg-muted rounded-full overflow-hidden">
        <div 
          className={`h-full ${color} transition-all duration-300`}
          style={{ width: hasData ? `${value}%` : "0%" }}
        />
      </div>
      <span className="text-xs text-muted-foreground w-8 text-right">
        {hasData ? `${Math.round(value)}%` : "--"}
      </span>
    </div>
  );
};
