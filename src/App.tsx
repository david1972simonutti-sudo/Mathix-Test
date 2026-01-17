import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Index from "./pages/Index";
import Login from "./pages/Login";
import Signup from "./pages/Signup";
import SignupParent from "./pages/SignupParent";
import EmailSent from "./pages/EmailSent";
import ConfirmEmail from "./pages/ConfirmEmail";
import ConfirmLogin from "./pages/ConfirmLogin";
import ForgotPassword from "./pages/ForgotPassword";
import ResetPassword from "./pages/ResetPassword";
import Exercise from "./pages/Exercise";
import Cours from "./pages/Cours";
import HistoriqueHome from "./pages/HistoriqueHome";
import HistoriqueExos from "./pages/HistoriqueExos";
import HistoriqueCours from "./pages/HistoriqueCours";
import Competences from "./pages/Competences";
import TestFormulas from "./pages/TestFormulas";
import Parents from "./pages/Parents";
import SuiviParent from "./pages/SuiviParent";
import Notice from "./pages/Notice";
import Objectifs from "./pages/Objectifs";
import Parametres from "./pages/Parametres";
import Aide from "./pages/Aide";
import GeneExercices from "./pages/GeneExercices";
import PresentationCache from "./pages/PresentationCache";
import NotFound from "./pages/NotFound";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Index />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/signup/parents" element={<SignupParent />} />
          <Route path="/email-sent" element={<EmailSent />} />
          <Route path="/confirm-email" element={<ConfirmEmail />} />
          <Route path="/confirm-login" element={<ConfirmLogin />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/reset-password" element={<ResetPassword />} />
          <Route path="/exercise" element={<Exercise />} />
          <Route path="/cours" element={<Cours />} />
          <Route path="/historique" element={<HistoriqueHome />} />
          <Route path="/historique_exos" element={<HistoriqueExos />} />
          <Route path="/historique_cours" element={<HistoriqueCours />} />
          <Route path="/competences" element={<Competences />} />
          <Route path="/test-formulas" element={<TestFormulas />} />
          <Route path="/notice" element={<Notice />} />
          <Route path="/parents" element={<Parents />} />
          <Route path="/suivi_parents/:enfantId" element={<SuiviParent />} />
          <Route path="/objectifs" element={<Objectifs />} />
          <Route path="/parametres" element={<Parametres />} />
          <Route path="/aide" element={<Aide />} />
          <Route path="/gene-exercices" element={<GeneExercices />} />
          <Route path="/presentation_cache" element={<PresentationCache />} />
          {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
