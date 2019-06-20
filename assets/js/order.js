// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import { Socket } from "phoenix"

let socket = new Socket("/manageorder/socket", { params: { token: window.userToken } })

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

let userOrderChannel = socket.channel("room:user-order", {})
let userOrderInput = document.querySelector("#user-add")
let userContainer = document.getElementById("user")

userOrderChannel.on('user_order_info', payload => {
  document.querySelector(".user-order").innerHTML = payload.html;

  alert(payload.html);
  console.log(payload);
})

document.querySelector("#product-order").style.visibility = 'hidden';
userOrderInput.addEventListener("change", event => {
  console.log(userOrderInput.value);
  userContainer.style.visibility = 'hidden';
  userContainer.style.display = 'none';
  document.querySelector("#product-order").style.visibility = 'visible';
})

userOrderChannel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


//let productOrderChannel = socket.channel("room:product-order", {})
//let productOrderInput = document.querySelector("#product-order-add")
//let productOrderContainer = document.querySelector("#product-order-container")

let user = document.getElementById("user-add").getAttribute
var theParent = document.querySelector("#product-order-add");

theParent.addEventListener("click", doSomething, false);

function doSomething(e) {
  if (e.target !== e.currentTarget) {
    alert(userOrderInput.value);
    console.log(userOrderInput.value);
    userOrderChannel.push("add_product", { product_id: e.target.value, user_id: userOrderInput.value })
  }
  e.stopPropagation();
}

userOrderChannel.on("add_product", payload => {
  console.log(payload);
})

let checkoutForm = document.getElementById("checkout-form")
userOrderChannel.on('add_product_to_cart_successful', payload => {
  let checkout = document.getElementById("checkout")

  if (checkout === null) {
    var btn = document.createElement("FORM");
    btn.setAttribute("id", "checkout");
    checkoutForm.appendChild(btn);

    var y = document.createElement("A");
    y.href = "/manageorder/" + userOrderInput.value;
    y.innerHTML = "CHECKOUT";
    btn.appendChild(y);
    checkout.appendChild(btn);
  };
  console.log(payload.user_id);
})

//productOrderChannel.join()
//  .receive("ok", resp => { console.log("Joined successfully", resp) })
//  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
