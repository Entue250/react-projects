import React, { useState } from "react";

function MyComponent() {
  const [name, setName] = useState("Guest");
  const [age, setAge] = useState(0);
  const [isEmployed, setIsEmployed] = useState(false);
  const [typing, setTyping] = useState("");

  const updateName = () => {
    setName("Entue");
  };

  const incrementAge = () => {
    setAge(age + 2);
  };

  const toggleEmployedStatus = () => {
    setIsEmployed(!isEmployed);
  };

  function handleTypeChanging(event) {
    setTyping(event.target.value);
  }

  return (
    <div>
      <p>Name: {name}</p>
      <button onClick={updateName}>Set Name</button>

      <input value={typing} onChange={handleTypeChanging} />
      <p>Typing: {typing}</p>

      <p>Age: {age}</p>
      <button onClick={incrementAge}>Increment Age</button>

      <p>Is employed: {isEmployed ? "Yes" : "No"}</p>
      <button onClick={toggleEmployedStatus}>Toggle Status</button>
    </div>
  );
}

export default MyComponent;
