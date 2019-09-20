import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Elm.Main.init();

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
