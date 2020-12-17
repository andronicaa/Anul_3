using Agenda.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;
using Agenda.ViewModels;

namespace Agenda.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
            
        }
        public DbSet<DailyTask> DailyTasks { get; set; }
        public DbSet<Person> Persons { get; set; }
        public DbSet<ContactInfo> ContactInfos { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            builder.Entity<Person>()
                .HasOne(b => b.ContactInfo)
                .WithOne(i => i.Person)
                .HasForeignKey<ContactInfo>(b => b.PersonRef);
        }

        public DbSet<Agenda.Models.ShoppingList> ShoppingList { get; set; }

        
    }
}
