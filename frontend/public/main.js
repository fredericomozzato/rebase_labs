const fragment = new DocumentFragment();
const url = 'http://localhost:4567/tests';

fetch(url).then((response) => response.json())
          .then((data) => {
            data.tests.forEach(function(test) {
              const tr = document.createElement('tr');
              
              for (const attr in test) {
                if (attr == 'id') {
                  continue;
                }
                
                const td = document.createElement('td');
                td.innerHTML = test[attr];
                tr.appendChild(td);
              }
              fragment.appendChild(tr);
            })
          })
          .then(() => {
            document.querySelector('tbody').appendChild(fragment);
          })
          .catch(function(error) {
            console.log(error);
          });
