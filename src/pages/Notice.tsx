import Header from "@/components/Header";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { useNavigate } from "react-router-dom";
import { ArrowLeft } from "lucide-react";
import GeometricBackground from "@/components/GeometricBackground";

const Notice = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen">
      <Header />
      <GeometricBackground className="pb-20">
        <div className="container mx-auto px-4 py-8 max-w-4xl">
        <Button
          variant="ghost"
          onClick={() => navigate("/")}
          className="mb-6"
        >
          <ArrowLeft className="mr-2 h-4 w-4" />
          Retour à l'accueil
        </Button>

        <Card className="border-[3px] border-primary rounded-xl shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-center mb-6">
              Notice d'utilisation du prototype (maj du 02/11)
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6 leading-relaxed">
            <p className="text-2xl">
              <strong>Intro :</strong> Le site n'est qu'un proto dans sa première version, il risque d'y avoir des bugs.
            </p>

            <ul className="space-y-2 ml-6 text-lg">
              <li className="list-disc">
                Le but du site est qu'il agisse comme un prof particulier, en se souvenant de ton historique, des choses que tu sais faire et les lacunes que tu aurais. Normalement, plus tu l'utilises, plus il te connaît et son contenu semble adapté à toi. C'est ça que je veux tester au travers de ce prototype.
              </li>
              <li className="list-disc">
                Il y a pour cela le bouton « Historique » où tu peux retrouver les énoncés des exos avec les chats que tu as eus, ou bien le bouton « Mes compétences » pour voir là où tu en es des chapitres traités, détaillés par sous-notion ensuite.
              </li>
              <li className="list-disc">
                Pour faire des exos et demander des explications de cours, clique sur : « Commencer mes exos ». Tu peux ouvrir un nouveau chat écrit ou avoir un chat vocal.
              </li>
            </ul>

            <div className="pt-4">
              <h3 className="font-bold mb-3 text-2xl">
                ⚡ NOUVEAUTÉ : ajout d'un clavier pour taper les formules mathématiques, juste à côté de l'ajout de photo.
              </h3>
            </div>

            <div className="pt-4">
              <h3 className="font-bold mb-3 text-2xl">
                Conseils d'utilisation pour éviter les bugs :
              </h3>
              <ul className="space-y-2 ml-6">
                <li className="list-disc">
                  ⚠️ Si tu as un problème d'affichage, appuie sur cmd+0 (cmd et 0) sur Mac et ctrl+0 sur Windows (ctrl et 0).
                </li>
                <li className="list-disc">
                  A chaque fois que tu veux un nouvel exo, appuie sur « créer un nouveau chat » en haut, cela évite les bugs.
                </li>
                <li className="list-disc">
                  Si l'exo n'est pas généré, ou ne respecte pas ta demande, refresh la page et crée un nouveau chat.
                </li>
              </ul>
              <p className="mt-3 ml-6">
                Pour demander un exo, commence ta phrase par : « génère… », ça garantit une génération d'exos.
              </p>
            </div>

            <div className="pt-4">
              <h3 className="font-bold mb-3 text-2xl">
                Problèmes actuels :
              </h3>
              <ul className="space-y-2 ml-6">
                <li className="list-disc">
                  Génération d'exercices qui parfois ne respecte pas ta demande
                </li>
              </ul>
            </div>

            <p className="text-center pt-6 font-medium">
              Merci encore de m'aider en utilisant le site !
            </p>
          </CardContent>
        </Card>
        </div>
      </GeometricBackground>
    </div>
  );
};

export default Notice;
