let page = 1;
let limit = 10;
let totalRows = 0;

document.addEventListener("DOMContentLoaded", fetchData);

document.addEventListener("keydown", function(e) {
  if (e.ctrlKey && e.key == "k") {
    e.preventDefault();
    
    const searchForm = document.querySelector("#search-field");
    if (searchForm) {
      searchForm.focus();
    }
  }
});

document.querySelector("#search-form").addEventListener("keydown", function(e) {
  if (e.key == "Enter") {
    e.preventDefault();
    searchBarQuery();
  }
})

function fetchData() {
  let url = `http://localhost:4567/tests?page=${page}&limit=${limit}`;
  const fragment = new DocumentFragment();
  
  fetch(url).then((response) => response.json())
            .then((data) => {
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
                card.setAttribute("style", "width: 30rem;")
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
                btn.setAttribute("onclick", `searchTest('${test.token}')`);
                
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

function firstPage() {
  page = 1;
  document.querySelector("#tests-list").innerHTML = "";
  fetchData();
}

function previousPage() {
  if (page > 1) {
    page--;
  }
  document.querySelector("#tests-list").innerHTML = "";
  fetchData();
}

function nextPage() {
  page++;
  document.querySelector("#tests-list").innerHTML = "";
  console.log(page);
  fetchData();
}

function searchBarQuery() {
  let token = document.querySelector("input#search-field").value;
  searchTest(token);
}

function searchTest(token) {
  const url = `http://localhost:4567/tests/${token}`;
  
  fetch(url).then((response) => response.json())
            .then((test) => {
              renderTestInfo(test);
            })
            .catch(function(error) {
              console.log(error);
              renderNotFound(token);
            });
}

function renderTestInfo(test) {
  // clear search form
  document.querySelector("input#search-field").value = "";

  // section
  const section = document.createElement("section");
  section.id = "test-info";
  section.className = "container mt-4 mb-4";
  
  // parent div
  const upperDiv = document.createElement("div");
  upperDiv.className = "bg-white rounded p-4 shadow-sm mb-3"
  
  // header
  const header = document.createElement("div");
  header.id = "header";
  header.className = "d-flex flex-row justify-content-between align-items-center";
    // h1
  const h1 = document.createElement("h1");
  h1.innerText = `Exame: ${test.token}`;
    // back button
  const backButton = document.createElement("a");
  backButton.href = "/exames";
  backButton.className = "btn btn-outline-primary";
  backButton.innerHTML = "&larr; Voltar";
  
  header.append(h1, backButton);
  upperDiv.append(header);
  
  // hr
  const hr = document.createElement("hr");
  upperDiv.append(hr);
  
  // row
  const row = document.createElement("div");
  row.className = "row";
  
  // patient info
  const patientInfo = document.createElement("div");
  patientInfo.id = "patient-info";
  patientInfo.className = "col";
  const patientTitle = document.createElement("h2");
  patientTitle.innerText = "Paciente";
    // patient details
  const patientDl = document.createElement("dl");
  patientDl.className = "list-group list-group-flush";
  const patientNameTerm = document.createElement("dt");
  patientNameTerm.innerText = "Nome:";
  const patientName = document.createElement("dd");
  patientName.className = "list-group-item";
  patientName.innerText = test.patient.name;
  const patientEmailTerm = document.createElement("dt");
  patientEmailTerm.innerText = "E-mail:";
  const patientEmail = document.createElement("dd");
  patientEmail.className = "list-group-item";
  patientEmail.innerText = test.patient.email;
  const birthdateTerm = document.createElement("dt");
  birthdateTerm.innerText = "Nascimento:";
  const patientBirthdate = document.createElement("dd");
  patientBirthdate.className = "list-group-item";
  let birthdate = new Date(Date.parse(test.patient.birthdate));
  patientBirthdate.innerText = birthdate.toLocaleDateString("pt-BR");
  
  patientDl.append(
    patientNameTerm, patientName, patientEmailTerm, patientEmail, birthdateTerm, patientBirthdate
  );
  patientInfo.append(patientTitle, patientDl);
  row.append(patientInfo);
  
  // doctor info
  const doctorInfo = document.createElement("div");
  doctorInfo.id = "doctor-info";
  doctorInfo.className = "col";
  const doctorTitle = document.createElement("h2");
  doctorTitle.innerText = "Médico";
    // doctor details
  const doctorDl = document.createElement("dl");
  doctorDl.className = "list-group list-group-flush";
  const doctorNameTerm = document.createElement("dt");
  doctorNameTerm.innerText = "Nome:";
  const doctorName = document.createElement("dd");
  doctorName.className = "list-group-item";
  doctorName.innerText = test.doctor.name;
  const crmTerm = document.createElement("dt");
  crmTerm.innerText = "CRM:";
  const doctorCrm = document.createElement("dd");
  doctorCrm.className = "list-group-item";
  doctorCrm.innerText = `${test.doctor.crm}/${test.doctor.crm_state}`;
  
  doctorDl.append(
    doctorNameTerm, doctorName, crmTerm, doctorCrm
  );
  doctorInfo.append(doctorTitle, doctorDl);
  
  row.append(doctorInfo);
  upperDiv.append(row);
  section.append(upperDiv);
  
  // test results
  const resultsElement = document.createElement("div");
  resultsElement.id = "results";
  resultsElement.className = "bg-white rounded p-4 shadow-sm";
  const resultsTitle = document.createElement("h2");
  resultsTitle.innerText = "Resultados";
  
  resultsElement.append(resultsTitle);
  
  // table
  const table = document.createElement("table");
  table.className = "table table-hover";
  // table header
  const thead = document.createElement("thead");
  const headRow = document.createElement("tr");
  
  const thType = document.createElement("th");
  thType.innerText = "Tipo";
  const thRange = document.createElement("th");
  thRange.innerText = "Intervalo";
  const thResult = document.createElement("th");
  thResult.innerText = "Resultado";
  
  headRow.append(thType, thRange, thResult);
  thead.append(headRow);
  table.append(thead);
  
  // table body
  const tbody = document.createElement("tbody");
  
  // iterate through results
  test.tests.forEach(t => {
    const tr = document.createElement("tr");
    // type
    const type = document.createElement("td");
    type.innerText = t.type;
    // range
    const range = document.createElement("td");
    range.innerText = t.range;
    // result
    const result = document.createElement("td");
    result.innerText = t.result;
    
    tr.append(type, range, result);
    tbody.append(tr);
  });
  table.append(tbody);
  
  resultsElement.append(table);
  section.append(resultsElement);
  
  const main = document.querySelector("main");
  main.innerHTML = "";
  main.append(section);
}

function renderNotFound(token) {
  const main = document.querySelector("main");
  main.innerHTML = "";
  const div = document.createElement("div");
  div.className = "text-center mt-5";
  const notFound = document.createElement("h1");
  notFound.innerText = `Nenhum exame encontrado com o token ${token}`;
  const message = document.createElement("p");
  message.innerText = "Confira o token ou importe novos exames usando o botão no menu";
  message.className = "text-muted mt-2";
  const backButton = document.createElement("a");
  backButton.className = "btn btn-outline-primary";
  backButton.innerText = "Voltar";
  backButton.href = "/exames";
  div.append(notFound, message, backButton);
  main.append(div);
}