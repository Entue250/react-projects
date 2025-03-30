function List(props) {
  const itemList = props.items;

  const category = props.category;
  const listItems = itemList.map((item) => (
    <li key={item.id}>
      {item.name} : &nbsp; <b>{item.calories}</b>
    </li>
  ));

  return (
    <>
      <h3 className="list-category">{category}</h3>
      <ol className="list-items">{listItems}</ol>
    </>
  );
}
export default List;
