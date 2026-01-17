import { MessageCircle } from "lucide-react";
import { useIsMobile } from "@/hooks/use-mobile";

interface GeometricBackgroundProps {
  children: React.ReactNode;
  className?: string;
  onContactClick?: () => void;
}

const GeometricBackground = ({ children, className = "", onContactClick }: GeometricBackgroundProps) => {
  const isMobile = useIsMobile();

  return (
    <div className={`relative ${className}`}>
      {/* Fond avec image fluide */}
      <div
        className="absolute inset-0 z-0 bg-white"
        style={{
          backgroundImage: `url('/images/background-siimply.png')`,
          backgroundSize: "cover",
          backgroundPosition: "bottom left",
          backgroundRepeat: "no-repeat",
        }}
      />

      {/* Contenu */}
      <div className="relative z-10">{children}</div>

      {/* Bouton flottant "Nous contacter" */}
      {onContactClick && (
        <button
          onClick={onContactClick}
          className={`absolute ${isMobile ? "bottom-2 right-2 w-10 h-10 p-0 justify-center" : "bottom-4 right-4 gap-1.5 px-3.5 py-2 text-sm"} z-40 flex items-center rounded-full text-white font-medium shadow-md hover:scale-105 hover:-translate-y-1 transition-all duration-200`}
          style={{
            background: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
            boxShadow: "0 8px 20px -5px rgba(102, 126, 234, 0.4)",
          }}
        >
          <MessageCircle className={isMobile ? "w-5 h-5" : "w-4 h-4"} />
          {!isMobile && "Nous contacter"}
        </button>
      )}
    </div>
  );
};

export default GeometricBackground;
