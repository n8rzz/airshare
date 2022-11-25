import { Model, ModelStatic } from 'sequelize';
import { AdapterAccount, AdapterSession, AdapterUser, VerificationToken } from 'next-auth/adapters';

// @see https://sequelize.org/master/manual/typescript.html
interface AccountInstance extends Model<AdapterAccount, Partial<AdapterAccount>>, AdapterAccount {
}

interface UserInstance extends Model<AdapterUser, Partial<AdapterUser>>, AdapterUser {
}

interface SessionInstance extends Model<AdapterSession, Partial<AdapterSession>>, AdapterSession {
}

interface VerificationTokenInstance extends Model<VerificationToken, Partial<VerificationToken>>, VerificationToken {
}

interface SequelizeAdapterOptions {
  models?: Partial<{
    Account: ModelStatic<AccountInstance>;
    Session: ModelStatic<SessionInstance>;
    User: ModelStatic<UserInstance>;
    VerificationToken: ModelStatic<VerificationTokenInstance>;
  }>;
  synchronize?: boolean;
}
