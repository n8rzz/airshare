import { AppHeader } from "../../src/components/shared/app-header/AppHeader";
import { RegisterPage } from "../../src/components/page-components/register-page/RegisterPage";

export default function Home() {
  return (
    <div>
      <AppHeader />
      <RegisterPage />
    </div>
  );
}
