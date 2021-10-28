# bundle
Import research data utility

Backend database tables, and sprocs to support and upload utility. The overall goal being to reduce index contention by creating individual partitions per upload. Each upload could be reviewed, and either promoted to production or removed and discarded. 
