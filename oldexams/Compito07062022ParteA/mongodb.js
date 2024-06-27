/* 1 */

db.movies.updateOne(
    {'title': 'Il Postino: The Postman'},
    {$addToSet: 
        {
            'actors': ['Linda Moretti', 'Nando Neri']
        }}
)

/* 2 */

db.movies.aggregate(
    [
        {
            $unwind: {
                path: '$actors'
            }
        },
        {
            $group:{
                '_id': '$actors',
                'numero_film:': {$sum: 1},
                'nomi_film': {$addToSet: '$title'}
            }
        },
        {
            $sort: {
                '_id':-1
            }
        }
    ]
)

/* 3 */

db.movies.aggregate([
    {
        $match: {genres: 'Comedy'}
    },
    {
        $sort : {"imdb.rating":-1, 'released.date': -1}
    }
])