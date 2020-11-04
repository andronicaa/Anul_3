using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using Laborator_3.Models;

namespace Laborator_3.DataAccessLayer
{

    public class DbCtx : DbContext
    {
        // Constructorul clasei apeleaza constructorul clasei de baza cu un parametru
        // si anume un string ce indica numele connection string-ului
        public DbCtx() : base("BookCS") 
        {
            Database.SetInitializer<DbCtx>(new Initp());
        }

        // avem proprietati de tip dbset ce vor reprezenta tabelele -> DbSet<T>
        // iar fiecare T va reprezenta tipul de obiect stocat in tabelul respectiv
        // NU PUTEM AVEA MAI MULT DE UN TABEL DE UN ANUMIT TIP DE DATE
        public DbSet<Book> Books { get; set; }
    }
}