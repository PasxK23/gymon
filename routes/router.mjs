import express from 'express';
const router = express.Router();



const my_controller = await import('../controller/controller.mjs')
const my_login_controller = await import('../controller/login-controller.mjs')


router.get('/', my_controller.someGymsRender);
router.get('/gyms', my_controller.allGymsRender);
router.get('/programs', my_controller.allProgramsRender);
router.get('/login', my_login_controller.checkAuthenticated, my_login_controller.showLogInForm);
router.get('/syndromes', my_controller.allSubscriptionsRender);
router.get('/syndromes-user/',my_login_controller.checkAuthenticated,  my_controller.userSubscriptionsRender);
router.get('/syndromes/:id', my_login_controller.checkAuthenticated, my_controller.userGetSubscription);
router.get('/syndromes-user/:id', my_login_controller.checkAuthenticated, my_controller.userGetSubscription);
router.get('/register', my_login_controller.checkAuthenticated, my_login_controller.showRegisterForm);
router.post('/register', my_login_controller.doRegister);
router.post('/login', my_login_controller.doLogin);
router.get('/gyms/:gym', my_controller.gymRender);
router.get('/programs/:program', my_controller.programRender);
router.get('/logout', my_login_controller.doLogout);
router.get('/profile', my_login_controller.checkAuthenticated, my_controller.showProfileRender);
router.get('/programma-gym', my_controller.gymSessionsRender);
router.get('/programma-gym/:id', my_login_controller.checkAuthenticated, my_controller.sessionManage);
router.get('/profile/:id', my_controller.renewSubscription);

export { router };