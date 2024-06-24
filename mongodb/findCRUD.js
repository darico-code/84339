//2. Visualizzare tutti gli studenti di una classe

let classe = "2B"

console.log(db.studenti.find({classe: classe}));

// 3. Visualizzare solo nome e cognome degli studenti

console.log(db.studenti.find({classe: classe}, {nome: 1, cognome: 1}))

// 4. Ordinare gli studenti per età

console.log(db.studenti.find({classe: classe}, {nome: 1, cognome: 1}).sort({età:1}))

// 5. Limitare l’output a soli 3 studenti

console.log(db.studenti.find({classe: classe}, {nome: 1, cognome: 1}).sort({età:1}).limit(3))