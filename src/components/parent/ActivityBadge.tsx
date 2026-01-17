import { formatDistanceToNow } from "date-fns";
import { fr } from "date-fns/locale";

interface ActivityBadgeProps {
  lastActivity: string | null;
}

export const ActivityBadge = ({ lastActivity }: ActivityBadgeProps) => {
  if (!lastActivity) {
    return (
      <span className="flex items-center gap-1 text-xs text-muted-foreground">
        <span className="w-2 h-2 rounded-full bg-muted-foreground/50" />
        Jamais connecté
      </span>
    );
  }

  const lastDate = new Date(lastActivity);
  const now = new Date();
  const diffHours = (now.getTime() - lastDate.getTime()) / (1000 * 60 * 60);

  let status: "online" | "recent" | "inactive";
  let color: string;
  
  if (diffHours < 2) {
    status = "online";
    color = "bg-green-500";
  } else if (diffHours < 72) {
    status = "recent";
    color = "bg-orange-400";
  } else {
    status = "inactive";
    color = "bg-red-400";
  }

  const timeAgo = formatDistanceToNow(lastDate, { addSuffix: true, locale: fr });

  return (
    <span className="flex items-center gap-1.5 text-xs text-muted-foreground">
      <span className={`w-2 h-2 rounded-full ${color}`} />
      {timeAgo}
    </span>
  );
};
