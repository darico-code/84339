/* 6. Aggiungere il campo "scuola" e "lastModified" a tutti i
documenti */

// db.studenti.updateMany({}, {$set: {scuola: "scuola1", lastModified: new Date()}})

/* 7. Aumentare la classe da "2B" a "3B" e l'età degli studenti */

// db.studenti.updateMany({classe: "2B"}, {$set: {classe: "3B"}, $inc: {età: 1}})

/* 8. Aggiungere un voto a un studente (dati nome e cognome) */

/*
let nome = "Mario";
let cognome = "Rossi";
let voto = 5;

db.studenti.updateOne({"nome": nome, "cognome": cognome}, {$push: {voti : voto} })
*/

/* 9. Eliminare tutti gli studenti di una classe */

/*
let classe = "3B"
db.studenti.deleteMany({"classe": classe});*/