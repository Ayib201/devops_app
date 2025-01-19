function calculateFactorial() {
  const number = document.getElementById("number").value;
  if (number === "") {
    alert("Please enter a number.");
    return;
  }

  // Construire l'URL avec le paramètre de requête
  const url = `http://localhost:8080/api/factorial?number=${encodeURIComponent(
    number
  )}`;
  // const url = "http://localhost:8080/api/factorial?number=4";

  // Effectuer la requête GET
  fetch(url, {
    method: "GET", // Utilisez GET au lieu de POST
    "Content-Type": "application/json",
  })
    .then((response) => response.json())
    .then((data) => {
      // Afficher le résultat
      document.getElementById("result").textContent = `Factorial: ${data}`;
    })
    .catch((error) => {
      console.error("Error:", error);
    });
}
