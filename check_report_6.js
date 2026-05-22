const { InspectionReport, Tyres, InspectionRequest } = require('./models');
const { sequelize } = require('./config/database');

async function checkReport() {
    try {
        const inspectionId = 6;
        console.log(`Checking report for inspection ID: ${inspectionId}`);

        const report = await InspectionReport.findOne({
            where: { inspection_request_id: inspectionId },
            include: [{ model: Tyres }]
        });

        if (!report) {
            console.log('Report not found for inspection ID 6');
            return;
        }

        console.log('Report found. ID:', report.id);
        console.log('Tyres data:', JSON.stringify(report.Tyres || report.tyres, null, 2));

        // Also check directly in Tyres table
        const allTyres = await Tyres.findAll({ where: { report_id: report.id } });
        console.log('Direct Tyres table check (all entries for this report_id):', JSON.stringify(allTyres, null, 2));

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await sequelize.close();
    }
}

checkReport();
