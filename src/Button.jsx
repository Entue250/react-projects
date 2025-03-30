function Button() {
  let count = 0;
  const handleClick = (name) => {
    if (count < 3) {
      count++;
      console.log(`${name}, you clicked me ${count} times`);
    } else {
      console.log(`${name} stop clicking me!`);
    }
  };

  const handleClick1 = (e) => (e.target.textContent = "OUCH! 🤔");

  return <button onClick={(e) => handleClick1(e)}>Click me 😂</button>;
}
export default Button;
