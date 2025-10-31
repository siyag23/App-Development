import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyA3W4N-nhkOVl6u9GuWheq4qbECE53kIP8",
  authDomain: "authapp-6ae92.firebaseapp.com",
  projectId: "authapp-6ae92",
  storageBucket: "authapp-6ae92.firebasestorage.app",
  messagingSenderId: "959877425117",
  appId: "1:959877425117:web:9e1f09648789430a31b834",
  measurementId: "G-MQMSY6XCY9",
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
