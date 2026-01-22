const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: 'home', component: () => import('pages/HomePage.vue') },
      {
        path: 'create',
        component: () => import('pages/CreateNote.vue'),
      },
      {
        path: 'lists',
        component: () => import('pages/NotesList.vue'),
      },
      { path: '', component: () => import('pages/LoginSignUp.vue') },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
]

export default routes
