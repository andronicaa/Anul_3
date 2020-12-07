using Laborator_7.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Laborator_7.Controllers
{
    public class BooksController : ApiController
    {

        private DbCtx ctx = new DbCtx();
        // afisam toate cartile din baza de date
        public List<Book> Get()
        {
            return ctx.Books.ToList();
        }

        // afisam o carte cu un id specificat
        public IHttpActionResult Get(int id)
        {
            Book book = ctx.Books.Find(id);
            if (book == null)
            {
                return NotFound();
            }
            return Ok(book);
        }

        // adaugare carte in baza de date
        public IHttpActionResult Post([FromBody] Book book)
        {
            ctx.Books.Add(book);
            ctx.SaveChanges();
            // helperul created contine pe langa obiectul nou-creat si adresa la care el va fi gasit
            var uri = new Uri(Url.Link("DefaultApi", new { id = book.BookId }));
            return Created(uri, book);
        }

        // edit
        public IHttpActionResult Put(int id, [FromBody] Book b)
        {
            Book book = ctx.Books.Find(id);
            if (book == null)
                return NotFound();
            book.Title = b.Title;
            book.Author = b.Author;
            ctx.SaveChanges();
            return Ok(book);
        }

        // actiunea de delete
        public IHttpActionResult Delete(int id)
        {
            Book book = ctx.Books.Find(id);
            if (book == null)
                return NotFound();
            ctx.Books.Remove(book);
            ctx.SaveChanges();
            return Ok(book);
        }
    }
}
