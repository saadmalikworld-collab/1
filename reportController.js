const {
    InspectionReport,
    InspectionRequest,
    BodyFrameChecklist,
    EngineTransmission,
    Brakes,
    SuspensionSteering,
    Interior,
    ACHeater,
    ElectricalElectronics,
    ExteriorBody,
    Tyres,
    TestDrive,
    User,
    Vehicle
} = require('../models');

// @desc    Create or update inspection report
// @route   POST /api/reports
// @access  Private/Inspector
exports.createOrUpdateReport = async (req, res) => {
    try {
        const {
            inspection_request_id,
            inspection_date,
            overall_rating,
            inspector_comments,
            body_frame,
            engine_transmission,
            brakes,
            suspension_steering,
            interior,
            ac_heater,
            electrical_electronics,
            exterior_body,
            tyres,
            test_drive,
            images
        } = req.body;

        // Check if inspection exists
        const inspection = await InspectionRequest.findByPk(inspection_request_id);
        if (!inspection) {
            return res.status(404).json({ error: 'Inspection request not found' });
        }

        // Check if report already exists
        let report = await InspectionReport.findOne({
            where: { inspection_request_id }
        });

        if (report) {
            // Update existing report
            await report.update({
                inspection_date,
                overall_rating,
                inspector_comments,
                images: images || []
            });
        } else {
            // Create new report
            report = await InspectionReport.create({
                inspection_request_id,
                inspector_id: req.user.id,
                inspection_date,
                overall_rating,
                inspector_comments,
                images: images || []
            });
        }

        // Helper function to upsert checklist
        const upsertChecklist = async (Model, data) => {
            if (!data) return;
            const existing = await Model.findOne({ where: { report_id: report.id } });
            if (existing) {
                await existing.update(data);
            } else {
                await Model.create({ report_id: report.id, ...data });
            }
        };

        // Update or create checklists
        await upsertChecklist(BodyFrameChecklist, body_frame);
        await upsertChecklist(EngineTransmission, engine_transmission);
        await upsertChecklist(Brakes, brakes);
        await upsertChecklist(SuspensionSteering, suspension_steering);
        await upsertChecklist(Interior, interior);
        await upsertChecklist(ACHeater, ac_heater);
        await upsertChecklist(ElectricalElectronics, electrical_electronics);
        await upsertChecklist(ExteriorBody, exterior_body);
        await upsertChecklist(Tyres, tyres);
        await upsertChecklist(TestDrive, test_drive);

        // Update inspection status
        await inspection.update({ status: 'completed' });

        res.json({
            message: 'Report saved successfully',
            report
        });
    } catch (error) {
        console.error('Create report error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Get report by inspection ID
// @route   GET /api/reports/:inspectionId
// @access  Private
exports.getReportByInspectionId = async (req, res) => {
    try {
        const report = await InspectionReport.findOne({
            where: { inspection_request_id: req.params.inspectionId },
            include: [
                { model: User, as: 'inspector', attributes: ['id', 'full_name', 'email'] },
                { model: BodyFrameChecklist, as: 'BodyFrameChecklist' },
                { model: EngineTransmission, as: 'EngineTransmission' },
                { model: Brakes, as: 'Brakes' },
                { model: SuspensionSteering, as: 'SuspensionSteering' },
                { model: Interior, as: 'Interior' },
                { model: ACHeater, as: 'ACHeater' },
                { model: ElectricalElectronics, as: 'ElectricalElectronics' },
                { model: ExteriorBody, as: 'ExteriorBody' },
                { model: Tyres, as: 'Tyres' },
                { model: TestDrive, as: 'TestDrive' },
                {
                    model: InspectionRequest,
                    include: [
                        { model: Vehicle },
                        { model: User, as: 'customer', attributes: ['id', 'full_name', 'email', 'phone'] }
                    ]
                }
            ]
        });

        if (!report) {
            return res.status(404).json({ error: 'Report not found' });
        }

        res.json({ report });
    } catch (error) {
        console.error('Get report error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Upload inspection images
// @route   POST /api/reports/:id/upload
// @access  Private/Inspector
exports.uploadImages = async (req, res) => {
    try {
        if (!req.files || req.files.length === 0) {
            return res.status(400).json({ error: 'No files uploaded' });
        }

        const filePaths = req.files.map(file => `/uploads/${file.filename}`);

        res.json({
            message: 'Images uploaded successfully',
            files: filePaths
        });
    } catch (error) {
        console.error('Upload images error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};
