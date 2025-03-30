import Button from "./Button";
import ColorPicker from "./ColorPicker";
import Counter from "./Counter";
import DigitalClock from "./DigitalClock";
import List from "./List";
import MyComponent from "./MyComponent";
import Stopwatch from "./Stopwatch";
import Student from "./Student";
import ToDoList from "./ToDoList";
import UpdateArrayState from "./UpdateArrayState";
import UserGreeting from "./UserGreeting";

function App() {
  const fruits = [
    { id: 1, name: "apple", calories: 95 },
    { id: 2, name: "orange", calories: 45 },
    { id: 3, name: "banana", calories: 105 },
    { id: 4, name: "coconut", calories: 159 },
    { id: 5, name: "pineapple", calories: 37 },
  ];

  const vegetables = [
    { id: 6, name: "potatoes", calories: 110 },
    { id: 7, name: "celery", calories: 15 },
    { id: 8, name: "carrots", calories: 25 },
    { id: 9, name: "corn", calories: 63 },
    { id: 10, name: "broccoli", calories: 50 },
  ];

  return (
    <>
      {/* <Student name="Spongebob" age={30} isStudent={true} />
      <Student name="Entue" age={42} isStudent={false} />
      <Student name="Frank" age={50} isStudent={false} />
      <Student name="Sandy" age={27} isStudent={true} />
      <Student />

      <UserGreeting isLoggedIn={true} username="Entue" /> */}

      {/* {fruits.length > 0 && <List items={fruits} category="Fruits" />}
      {vegetables.length > 0 && (
        <List items={vegetables} category="Vegetables" />
      )}

      <Button /> */}

      {/* <MyComponent />

      <Counter /> */}

      {/* <ColorPicker /> */}

      {/* <UpdateArrayState /> */}

      {/* <ToDoList /> */}

      {/* <DigitalClock /> */}

      <Stopwatch />
    </>
  );
}

export default App;
