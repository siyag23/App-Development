import React from "react";
import { View, Text, TouchableOpacity, ImageBackground, StyleSheet } from "react-native";
import { COLORS } from "../theme";

export default function WelcomeScreen({ navigation }) {
  return (
    <ImageBackground
      source={{ uri: "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2" }}
      style={styles.container}
    >
      <View style={styles.overlay}>
        <Text style={styles.title}>Welcome!</Text>
        <Text style={styles.subtitle}>Experience seamless authentication</Text>

        <TouchableOpacity
          style={styles.button}
          onPress={() => navigation.navigate("SignIn")}
        >
          <Text style={styles.buttonText}>Sign In</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.button, styles.secondaryButton]}
          onPress={() => navigation.navigate("SignUp")}
        >
          <Text style={[styles.buttonText, styles.secondaryButtonText]}>
            Sign Up
          </Text>
        </TouchableOpacity>
      </View>
    </ImageBackground>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  overlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.6)",
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 36,
    color: COLORS.white,
    fontWeight: "bold",
    marginBottom: 10,
  },
  subtitle: { color: COLORS.white, marginBottom: 40 },
  button: {
    backgroundColor: COLORS.primary,
    width: "80%",
    padding: 15,
    borderRadius: 30,
    alignItems: "center",
    marginBottom: 15,
  },
  secondaryButton: {
    backgroundColor: COLORS.white,
  },
  buttonText: { color: COLORS.white, fontSize: 16, fontWeight: "600" },
  secondaryButtonText: { color: COLORS.primary },
});
