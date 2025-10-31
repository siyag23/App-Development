import React from "react";
import { View, Text, Button } from "react-native";
import { signOut } from "firebase/auth";
import { auth } from "../firebaseConfig";

export default function ProfileScreen({ navigation }) {
  const handleSignOut = async () => {
    await signOut(auth);
    navigation.replace("SignIn");
  };

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Email: {auth.currentUser?.email || "Phone User"}</Text>
      <Button title="Sign Out" onPress={handleSignOut} />
    </View>
  );
}
