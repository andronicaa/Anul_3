using Laborator_3.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI.WebControls;

namespace Laborator_3.DataAccessLayer
{
    public class Initp : DropCreateDatabaseAlways<DbCtx>
    {
        protected override void Seed (DbCtx ctx)
        {
            ctx.Books.Add(new Book
            {
                Title = "The Atomic Times",
                Author = "Michael Harris",
                DateCreation = DateTime.Now,
                Summary = "Blabla"
            });
            ctx.Books.Add(new Book
            {
                Title = "In Defense of Elitism",
                Author = "Joel Stein",
                DateCreation = DateTime.Now,
                Summary = "Blabla"
            });
            ctx.SaveChanges();
            base.Seed(ctx);

        }
    }
}