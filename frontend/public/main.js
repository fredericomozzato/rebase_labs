let page = 1;
let limit = 25;
let totalRows = 0;const fragment = new DocumentFragment();

document.addEventListener("DOMContentLoaded", fetchData());

function fetchData() {
  let url = `http://localhost:4567/tests?page=${page}&limit=${limit}`;
  
  fetch(url).then((response) => response.json())
          .then((data) => {
            console.log(data);
            data.tests.forEach(function(test) {
              const tr = document.createElement("tr");
              
              for (const attr in test) {
                if (attr == 'id') {
                  continue;
                } else if (attr == "patient_birthdate" || attr == "test_date") {
                  let date = new Date(Date.parse(test[attr]));
                  test[attr] = date.toLocaleDateString("pt-BR");
                }
                
                const td = document.createElement("td");
                td.innerHTML = test[attr];
                tr.appendChild(td);
              }
              fragment.appendChild(tr);
            })
          })
          .then(() => {
            document.querySelector("tbody").appendChild(fragment);
            document.querySelector("#page-number").innerHTML = page;
            document.querySelector("#limit").value = limit;
          })
          .catch(function(error) {
            console.log(error);
          });
}

function firstPage() {
  page = 1;
  document.querySelector("tbody").innerHTML = "";
  fetchData();
}

function previousPage() {
  if (page > 1) {
    page--;
  }
  document.querySelector("tbody").innerHTML = "";
  fetchData();
}

function nextPage() {
  page++;
  document.querySelector("tbody").innerHTML = "";
  fetchData();
}

function changeLimit() {
  let selector = document.querySelector("#limit");
  limit = selector.value;
  document.querySelector("tbody").innerHTML = "";
  fetchData();
}