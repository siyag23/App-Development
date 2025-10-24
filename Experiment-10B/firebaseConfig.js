// firebaseConfig.js
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

// Your Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyCptbbvr7CvRExd0XGu2yZsZcobQ0V88",
  authDomain: "fir-todo-782c2.firebaseapp.com",
  projectId: "fir-todo-782c2",
  storageBucket: "fir-todo-782c2.appspot.com",
  messagingSenderId: "162221078251",
  appId: "1:162221078251:web:d78f3c9dBe3ecbfc0564ee",
  measurementId: "G-M2CBHBFQ4W",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Export Firestore database
export const db = getFirestore(app);
