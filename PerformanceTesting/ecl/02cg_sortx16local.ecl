import perform.config, perform.format, perform.files;

numRecords := config.simpleRecordCount * 16;
ds := files.generateN(0, numRecords);

sortedDs := sort(ds, id3, LOCAL);

output(COUNT(NOFOLD(sortedDs)) = numRecords);
