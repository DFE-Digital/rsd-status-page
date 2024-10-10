const endpoints = [
]

const secondsToWait = 300;

document.getElementById('waitTime').textContent = (secondsToWait / 60);

async function GET(label, url) {
  const resultBody = document.getElementById('resultBody');

  try {
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "X-User-Agent": "RsdStatusPage/1.0"
      },
    });

    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }

    await response.json()
      .then((data) => {
        if (data.message != 'Success') {
          throw new Error(data.message);
        }

        const rowItem = document.createElement("tr");
        rowItem.setAttribute('class', 'govuk-table__row');

        const rowHeader = document.createElement("th");
        rowHeader.setAttribute('scope', 'row');
        rowHeader.setAttribute('class', 'govuk-table__header');
        rowHeader.textContent = label;
        rowItem.appendChild(rowHeader);

        const cellItem = document.createElement("td");
        cellItem.setAttribute('class', 'govuk-table__cell govuk-table__cell--numeric');

        data.body.sort((a, b) => (a.location > b.location ? 1 : -1));

        for (const webTest of data.body) {
          const locationItem = document.createElement("span");
          locationItem.setAttribute('class', 'govuk-tag ' + (webTest.success ? 'good' : 'bad'));
          locationItem.setAttribute('title', webTest.location + ": " + (webTest.success ? 'up' : 'down'));
          locationItem.textContent = (webTest.success ? 'up' : 'down');
          cellItem.appendChild(locationItem);
        }

        rowItem.appendChild(cellItem);
        resultBody.appendChild(rowItem);
      })

  } catch (error) {
    console.error(error);
  }
}

function run() {
  const resultTable = document.getElementById('resultTable');
  resultTable.style["cursor"] = "wait";
  resultTable.style["opacity"] = "0.2";

  const resultBody = document.getElementById('resultBody');
  resultBody.innerHTML = '';

  const lastModified = document.getElementById('lastModifiedTime');
  lastModified.style["display"] = "none";

  const warningMessage = document.getElementById('wait');
  warningMessage.style["display"] = "block";

  let queue = [];
  endpoints.forEach((value, index) => {
    queue.push(GET(value.label, value.endpoint))
  });

  Promise.all(queue).then(() => {
    const date = new Date();
    lastModified.textContent = "Last updated: " + date.getDate() +
      "/" +
      (date.getMonth() + 1) + // Zero indexed months
      "/" +
      date.getFullYear() +
      " " +
      date.toLocaleTimeString();

    lastModified.style["display"] = "block";
    warningMessage.style["display"] = "none";

    resultTable.style["cursor"] = "auto";
    resultTable.style["opacity"] = "1";
  })
}

run();

setInterval(function(){
  run();
}, secondsToWait * 1000);
