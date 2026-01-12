importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDIUOaVDvGZmhm1hweEPIHI2v_WfRhVP7o",
  authDomain: "attendance-dpmptsp.firebaseapp.com",
  projectId: "attendance-dpmptsp",
  storageBucket: "attendance-dpmptsp.firebasestorage.app",
  messagingSenderId: "746800149870",
  appId: "1:746800149870:web:4886cca4c84ca97b3afd7f",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});