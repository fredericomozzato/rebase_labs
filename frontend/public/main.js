let page = 1;
let limit = 10;
let totalRows = 0;
const fragment = new DocumentFragment();

document.addEventListener("DOMContentLoaded", fetchData());

function fetchData() {
  let url = `http://localhost:4567/tests?page=${page}&limit=${limit}`;
  
  fetch(url).then((response) => response.json())
          .then((data) => {
            console.log(data);
            
            // empty state
            if (data.length === 0) {
              const div = document.createElement("div");
              const emptyState = document.createElement("h3");
              emptyState.innerText = "Nenhum exame encontrado";
              emptyState.className = "display-5 fs-3 text-muted"
              div.append(emptyState);
              fragment.append(div);
              
              // hide navigation buttons
              document.querySelector("#navigation-btns").className += " d-none";
            }
            
            data.forEach(function(test) {
              // main card structure
              const card = document.createElement("div");
              card.className = "card shadow shadow-sm";
              card.setAttribute("style", "width: 33rem;")
              const cardBody = document.createElement("div");
              cardBody.className = "card-body";
              const row = document.createElement("div");
              row.className = "row";
              
              // first col
              const col1 = document.createElement("div");
              col1.className = "col-md-5 text-center border-end d-flex flex-column justify-content-around p-2";
              
              const token = document.createElement("h2");
              token.className = "card-title display-6";
              token.innerText = test.token;
              
              const dateElement = document.createElement("p");
              dateElement.className = "text-muted"
              let date = new Date(Date.parse(test.date));
              dateElement.innerText = date.toLocaleDateString("pt-BR");
              
              const btn = document.createElement("a");
              btn.className = "btn btn-sm btn-outline-primary";
              btn.innerText = "Detalhes";
              btn.setAttribute("href", "/");
              
              col1.append(token, dateElement, btn);
              
              // second col
              const col2 = document.createElement("div");
              col2.className = "col-md-7";
              
              const cardText = document.createElement("div");
              cardText.className = "card-text"
              
              // description list
              const dl = document.createElement("dl");
              dl.className = "list-group list-group-flush"
                // patient
              const patientDt = document.createElement("dt");
              patientDt.className = "small text-muted";
              patientDt.innerText = "Paciente:";
              const patientName = document.createElement("dd");
              patientName.className = "list-group-item";
              patientName.innerText = test.patient.name;
                // doctor
              const doctorDt = document.createElement("dt");
              doctorDt.className = "small text-muted";
              doctorDt.innerText = "Médico:";
              const doctorName = document.createElement("dd");
              doctorName.className = "list-group-item";
              doctorName.innerText = test.doctor.name;
              
              dl.append(patientDt, patientName, doctorDt, doctorName);
              cardText.append(dl);
              col2.append(cardText);
              
              // build card
              row.append(col1, col2);
              cardBody.append(row);
              card.append(cardBody);
              
              fragment.appendChild(card);
            })
          })
          .then(() => {
            document.querySelector("#tests-list").appendChild(fragment);
            document.querySelector("#page-number").innerHTML = page;
          })
          .catch(function(error) {
            console.log(error);
          });
}

// function firstPage() {
//   page = 1;
//   document.querySelector("tbody").innerHTML = "";
//   fetchData();
// }

// function previousPage() {
//   if (page > 1) {
//     page--;
//   }
//   document.querySelector("tbody").innerHTML = "";
//   fetchData();
// }

// function nextPage() {
//   page++;
//   document.querySelector("tbody").innerHTML = "";
//   fetchData();
// }

// function changeLimit() {
//   let selector = document.querySelector("#limit");
//   limit = selector.value;
//   document.querySelector("tbody").innerHTML = "";
//   fetchData();
// }