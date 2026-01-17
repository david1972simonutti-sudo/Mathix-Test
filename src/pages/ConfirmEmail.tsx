import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { AlertCircle } from "lucide-react";
import { Link, useNavigate } from "react-router-dom";
import { useEffect } from "react";

const ConfirmEmail = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Rediriger immédiatement vers /confirm-login
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');
    
    if (token) {
      navigate(`/confirm-login?token=${token}`, { replace: true });
    }
  }, [navigate]);

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center space-y-4">
          <div className="mx-auto w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
            <AlertCircle className="w-8 h-8 text-primary" />
          </div>
          <CardTitle className="text-2xl">Redirection...</CardTitle>
          <CardDescription className="text-base">
            Vous allez être redirigé vers la page de confirmation.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Link to="/confirm-login">
            <Button className="w-full">
              Continuer vers la confirmation
            </Button>
          </Link>
        </CardContent>
      </Card>
    </div>
  );
};

export default ConfirmEmail;
