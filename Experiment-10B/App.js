import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  FlatList,
  StyleSheet,
} from "react-native";

import {
  collection,
  addDoc,
  getDocs,
  deleteDoc,
  doc,
  updateDoc,
} from "firebase/firestore";
import { db } from "./firebaseConfig";

export default function App() {
  const [task, setTask] = useState("");
  const [tasks, setTasks] = useState([]);

  // Fetch tasks from Firestore
  const fetchTasks = async () => {
    try {
      const querySnapshot = await getDocs(collection(db, "tasks"));
      const taskList = querySnapshot.docs.map((docSnap) => ({
        id: docSnap.id,
        ...docSnap.data(),
      }));
      setTasks(taskList);
    } catch (error) {
      console.log("Error fetching tasks:", error);
    }
  };

  // Add a new task
  const addTask = async () => {
    if (task.trim().length === 0) return;
    try {
      await addDoc(collection(db, "tasks"), { name: task, completed: false });
      setTask("");
      fetchTasks();
    } catch (error) {
      console.log("Error adding task:", error);
    }
  };

  // Delete a task
  const deleteTask = async (id) => {
    try {
      await deleteDoc(doc(db, "tasks", id));
      fetchTasks();
    } catch (error) {
      console.log("Error deleting task:", error);
    }
  };

  // Mark task as completed
  const markTaskDone = async (id, completed) => {
    try {
      const taskRef = doc(db, "tasks", id);
      await updateDoc(taskRef, { completed: !completed }); // toggle completed
      fetchTasks();
    } catch (error) {
      console.log("Error updating task:", error);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>🔥 To-Do List (Firebase)</Text>

      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Enter a task..."
          value={task}
          onChangeText={setTask}
        />
        <TouchableOpacity style={styles.addButton} onPress={addTask}>
          <Text style={styles.addText}>Add</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={tasks}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View style={styles.taskContainer}>
            {/* Checkbox on the left */}
            <TouchableOpacity
              style={[
                styles.checkbox,
                { backgroundColor: item.completed ? "#4CAF50" : "#fff" },
              ]}
              onPress={() => markTaskDone(item.id, item.completed)}
            >
              {item.completed && <Text style={styles.checkmark}>✔</Text>}
            </TouchableOpacity>

            <Text
              style={[
                styles.taskText,
                { textDecorationLine: item.completed ? "line-through" : "none" },
              ]}
            >
              {item.name}
            </Text>

            <TouchableOpacity onPress={() => deleteTask(item.id)}>
              <Text style={styles.deleteText}>❌</Text>
            </TouchableOpacity>
          </View>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: "#fff" },
  title: { fontSize: 26, fontWeight: "bold", marginBottom: 20, textAlign: "center" },
  inputContainer: { flexDirection: "row", marginBottom: 20 },
  input: {
    flex: 1,
    borderColor: "#ccc",
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 10,
  },
  addButton: {
    backgroundColor: "#4CAF50",
    marginLeft: 10,
    borderRadius: 8,
    paddingHorizontal: 15,
    justifyContent: "center",
  },
  addText: { color: "#fff", fontWeight: "bold" },
  taskContainer: {
    flexDirection: "row",
    alignItems: "center",
    padding: 15,
    borderBottomWidth: 1,
    borderColor: "#eee",
  },
  checkbox: {
    width: 24,
    height: 24,
    borderWidth: 2,
    borderColor: "#4CAF50",
    borderRadius: 4,
    marginRight: 15,
    justifyContent: "center",
    alignItems: "center",
  },
  checkmark: { color: "#fff", fontWeight: "bold" },
  taskText: { fontSize: 18, flex: 1 },
  deleteText: { fontSize: 20, marginLeft: 10 },
});
