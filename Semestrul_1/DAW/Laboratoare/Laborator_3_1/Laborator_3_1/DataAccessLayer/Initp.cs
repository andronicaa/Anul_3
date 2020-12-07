using Laborator_3_1.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace Laborator_3_1.DataAccessLayer
{
    public class Initp : DropCreateDatabaseAlways<MyDbCtx>
    {
        protected override void Seed(MyDbCtx ctx)
        {
            BookType tipOne = new BookType { BookTypeId = 6, Name = "HardCover" };
            BookType tipTwo = new BookType { BookTypeId = 7, Name = "Paperback" };

            // trebuie sa adaug cele doua tipuri in baza de date
            ctx.BookTypes.Add(tipOne);
            ctx.BookTypes.Add(tipTwo);

            // trebuie sa adaug pentru fiecare carte ca si cheie externa un tip
            ctx.Books.Add(new Book
            {
                Title = "The Atomic Times",
                Author = "Michael Harris",
                Publisher = new Publisher
                {
                    Name = "HarperCollins",
                    ContactInfo = new ContactInfo
                    {
                        PhoneNumber = "07123456789"
                    }
                },
                BookTypeId = tipOne.BookTypeId,
                Genres = new List<Genre> { new Genre { Name = "Horror" } }
            }) ;
            ctx.Books.Add(new Book
            {
                Title = "In Defense of Elitism",
                Author = "Joel Stein",
                Publisher = new Publisher
                {
                    Name = "Macmillan Publishers",
                    ContactInfo = new ContactInfo
                    {
                        PhoneNumber = "07123458789"
                    }
                },
                BookTypeId = tipTwo.BookTypeId,
                Genres = new List<Genre> {new Genre { Name = "Humor"}
 }
            });
            ctx.Books.Add(new Book
            {
                Title = "The Canterbury Tales",
                Author = "Geoffrey Chaucer",
                Summary = "At the Tabard Inn, a tavern in Southwark, near London, the narrator joins a company of twenty - nine pilgrims.",
                Publisher = new Publisher
                        {
                            Name = "Scholastic",
                            ContactInfo = new ContactInfo
                            {
                                PhoneNumber = "07113456789"
                            }
                        },
                BookTypeId = tipOne.BookTypeId,
                Genres = new List<Genre> 
                        {
                         new Genre { Name = "Satire"},
                         new Genre { Name = "Fabilau"},
                         new Genre { Name = "Allegory"},
                         new Genre { Name = "Burlesque"}
                         }
            });
            ctx.Books.Add(new Book
            {
                Title = "Python Crash Course, 2nd Edition: A Hands-On, Project-Based Introduction to Programming",
                Author = "Eric Matthers",
                Publisher = new Publisher
                {
                    Name = "Schol",
                    ContactInfo = new ContactInfo
                    {
                        PhoneNumber = "07126656789"
                    }
                },
                BookTypeId = tipTwo.BookTypeId,
                Genres = new List<Genre> 
                {
                        new Genre { Name = "Programming"}
                   }
            });
            
            ctx.SaveChanges();
            base.Seed(ctx);
        }
    }
}