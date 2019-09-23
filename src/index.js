import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const flags = {data: {}};
const currentUser = JSON.parse(localStorage.getItem('currentUser'));
if (currentUser) {
  flags.data.email = currentUser.email;
}

const app = Elm.Main.init({ flags });

// Ports
app.ports.sessionStore.subscribe((payload) => {
  const { type, data } = payload;
  switch (type) {

    case 'setCurrentUser':
      localStorage.setItem('currentUser', JSON.stringify(data));
      const { email } = data;
      app.ports.sessionChanged.send({
        type: 'setSession',
        data: { email }
      })
      break;

    case 'clearCurrentUser':
      localStorage.removeItem('currentUser');
      app.ports.sessionChanged.send({
        type: "clearSession"
      });
      break;

    default:
      break;
  }
});

registerServiceWorker();
