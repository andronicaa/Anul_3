using Laborator_3_1.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace Laborator_3_1.DataAccessLayer
{
    public class MyDbCtx : DbContext
    {
        public MyDbCtx() : base("BookCS") 
        {
            Database.SetInitializer<MyDbCtx>(new Initp());
        }
        public DbSet<Book> Books { get; set; }
        public DbSet<Publisher> Publishers { get; set; }
        public DbSet<Genre> Genres { get; set; }
        public DbSet<ContactInfo> ContactsInfo { get; set; }
        public DbSet<BookType> BookTypes { get; set; }
        

    }
}