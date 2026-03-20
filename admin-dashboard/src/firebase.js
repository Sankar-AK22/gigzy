import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyAO4A3h_NctZbgdClhXSHewHClNaNJNdxs",
  appId: "1:523779007893:web:25f21cd424d7e805d1429c",
  messagingSenderId: "523779007893",
  projectId: "gigzy-639da",
  authDomain: "gigzy-639da.firebaseapp.com",
  storageBucket: "gigzy-639da.firebasestorage.app",
  measurementId: "G-2P81TQXG4J"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
