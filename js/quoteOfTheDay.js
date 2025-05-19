
const nameMap = {'Branson': 'Branson', 
                'Jeff': 'Jeff', 
                'Cass': 'Cass', 
                'Steven': 'Steven', 
                'Sam U': 'Boy Sam', 
                'Mackenzie S': 'Mackenzie S.', 
                'Mackenzie M': 'Mackenzie M.', 
                'Sam R': 'Girl Sam', 
                'Neely': 'Neely', 
                'Elena': 'Elena', 
                'Holly': 'Holly', 
                'Tyler': 'Tyler',
                'Grace': 'Grace'};


// async function getQuoteOfTheDay() {
//   return fetch('/quote-of-the-day').then((response) => {
//       if (!response.ok) {
//         throw new Error('Network response was not ok');
//       }
//       return response.json();
//     }).then((data) => {
//       const { text, author } = data;
//       console.log(nameMap[author]);
//       const authorValue = nameMap[author];
//       return { text, authorValue };
//     }).catch((error) => {
//       console.error('Error fetching quote of the day:', error);
//     });
// }

async function getQuoteOfTheDay(desiredDate) {
  // Convert the desired date to a format the server expects (e.g., "YYYY-MM-DD")
  // If no date is provided, it will default to current day on the server.
  const dateParam = desiredDate ? `?date=${desiredDate}` : "";
  return fetch(`/quote-of-the-day${dateParam}`).then((response) => {
      if (!response.ok) {
          throw new Error('Network response was not ok');
      }
      return response.json();
    }).then((data) => {
      // Assuming nameMap mapping still exists, else use data.author directly
      const { text, author } = data;
      const authorValue = nameMap[author];
      return { text, authorValue };
    }).catch((error) => {
      console.error('Error fetching quote of the day:', error);
    });
}

function ScrollHeight() {
  var content = document.querySelector('#parchment');
  var container = document.querySelector('#theblockquote');

  const height = container.offsetHeight + 80;

  // SVG feTurbulence can modify all others elements, for this reason "parchment" is in another <div> and in absolute position.
  // so for a better effect, absolute height is defined by his content.
  content.style.height = height + 'px';
}

window.addEventListener('resize', function (event) {
  ScrollHeight();
});

window.addEventListener("load", async () => {
  try {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0'); // getMonth() returns 0-11 so add 1
    const day = String(now.getDate()).padStart(2, '0');
    const formattedDate = `${year}-${month}-${day}`;
    console.log(formattedDate);
    const { text, authorValue } = await getQuoteOfTheDay(formattedDate);
    document.getElementById("quote").textContent = text;
    document.getElementById("author").textContent = `- ${authorValue}`;
    ScrollHeight();

  } catch (error) {
    console.error(error);
    document.getElementById("quote").textContent = "Error loading quote.";
  }
});