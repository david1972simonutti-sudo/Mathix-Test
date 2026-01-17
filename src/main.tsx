import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import "katex/dist/katex.min.css";
import "./katex-minimal.css";
import "./index.css";

createRoot(document.getElementById("root")!).render(<App />);
